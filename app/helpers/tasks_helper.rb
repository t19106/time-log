# このモジュールの内部では、Task情報をActiveRecord Relationとして渡された時は、
# tasksをmap(&:attributes)によってハッシュ化してからデータを扱う
module TasksHelper
  def show_date(time)
    time.strftime('%Y年%m月%d日')
  end

  def show_time_from_task(task, date)
    _task = check_range([task], date).first
    "#{_task['start_at'].strftime('%H:%M')} ~ #{_task['end_at'].strftime('%H:%M')}"
  end

  def time_format_from_task(task, date)
    _task = check_range([task], date).first
    time_format(to_hours(_task), to_minutes(_task))
  end

  def set_time_select_to_now(date)
    _min = Time.now.min.floor.round(-1)
    if _min == 60
      Time.new(date.year, date.month, date.day, (Time.now + 3600).hour, 0)
    else
      Time.new(date.year, date.month, date.day, Time.now.hour, _min)
    end
  end

  def total_time_from_tasks(tasks, date)
    return false if tasks.empty?
    times = take_hours_and_minutes(check_range(tasks, date))
    time_format(times[:hours], times[:minutes])
  end

  def time_format(hours, minutes)
    if hours > 0
      minutes == 0 ? "#{hours}時間" : "#{hours}時間#{minutes}分"
    else
      "#{minutes}分"
    end
  end

  # to_hours, to_minutes:
  # 引数taskにはattributesがキー化されたハッシュを渡す。ActiveRecord Relationは対応外とする
  def to_hours(task)
    ((task['end_at'] - task['start_at']) / 60 / 60).to_i
  end

  def to_minutes(task)
    (((task['end_at'] - task['start_at']) / 60) % 60).to_i
  end

  def take_hours_and_minutes(tasks)
    _tasks = tasks.map { |task| { hours: to_hours(task), minutes: to_minutes(task) } }
    hours = _tasks.inject(0) { |total, task| total + task[:hours] }
    minutes = _tasks.inject(0) { |total, task| total + task[:minutes] }
    recalculate(hours, minutes)
  end

  def recalculate(hours, minutes)
    if minutes >= 60
      minutes == 60 ? hours += 1 : hours += minutes % 60
      minutes %= 60
    end
    { hours: hours, minutes: minutes }
  end

  # check_range:
  # oor = out of range
  # ここでActiveRecord Relationをハッシュ化する
  def check_range(tasks, date)
    oor_tasks = tasks.map(&:attributes).find_all { |task| (task['start_at'] < date.beginning_of_day) || (task['end_at'] > date.end_of_day) }
    _tasks = Task.where(user: current_user, start_at: date.beginning_of_day..date.end_of_day, end_at: date.beginning_of_day..date.end_of_day).map(&:attributes)
    if oor_tasks.first['start_at'] < date.beginning_of_day
      oor_beginning = oor_tasks.first
      oor_beginning['start_at'] = oor_beginning['start_at'].change(day: date.day, hour: 0, min: 0)
    elsif oor_tasks.first['end_at'] > date.end_of_day
      oor_end = oor_tasks.first
      oor_end['end_at'] = oor_end['end_at'].change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    if oor_tasks.size == 2
      oor_end = oor_tasks.last
      oor_end['end_at'] = oor_end['end_at'].change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    _tasks.unshift(oor_beginning) if oor_beginning
    _tasks.push(oor_end) if oor_end
    _tasks
  end
end
