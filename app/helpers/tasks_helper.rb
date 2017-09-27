module TasksHelper
  def show_date(time)
    time.strftime('%Y年%m月%d日')
  end

  def time_range_format(task, date)
    "#{task.start_at.strftime('%H:%M')} ~ #{task.end_at.strftime('%H:%M')}"
  end

  def time_format_from_task(task, date)
    time_format(task.to_hours, task.to_minutes)
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
    times = take_hours_and_minutes(tasks, date)
    time_format(times[:hours], times[:minutes])
  end

  def time_format(hours, minutes)
    if hours > 0
      minutes == 0 ? "#{hours}時間" : "#{hours}時間#{minutes}分"
    else
      "#{minutes}分"
    end
  end

  def take_hours_and_minutes(tasks, date)
    _tasks = tasks.map { |task| { hours: task.to_hours, minutes: task.to_minutes } }
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
