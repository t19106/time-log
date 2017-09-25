module ApplicationHelper
  def show_date(time)
    time.strftime('%Y年%m月%d日')
  end

  def show_time_from_task(task)
    "#{task.start_at.strftime('%H:%M')} ~ #{task.end_at.strftime('%H:%M')}"
  end

  def set_time_select_to_now(date)
    _min = Time.now.min.floor.round(-1)
    if _min == 60
      Time.new(date.year, date.month, date.day, (Time.now + 3600).hour, 0)
    else
      Time.new(date.year, date.month, date.day, Time.now.hour, _min)
    end
  end

  def time_format_from_task(task)
    time_format(to_hours(task), to_minutes(task))
  end

  def total_time_from_tasks(tasks)
    return false if tasks.empty?
    times = take_hours_and_minutes(tasks)
    time_format(times[:hours], times[:minutes])
  end

  def time_format(hours, minutes)
    if hours > 0
      minutes == 0 ? "#{hours}時間" : "#{hours}時間#{minutes}分"
    else
      "#{minutes}分"
    end
  end

  def to_hours(task)
    ((task.end_at - task.start_at) / 60 / 60).to_i
  end

  def to_minutes(task)
    (((task.end_at - task.start_at) / 60) % 60).to_i
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
end
