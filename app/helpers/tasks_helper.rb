module TasksHelper
  def show_time_range(task)
    "#{l task.starts_at, format: :time} ~ #{l task.ends_at, format: :time}"
  end

  def set_time_select_to_now(date)
    _min = Time.zone.now.min.floor.round(-1)
    if _min == 60
      Time.zone.local(date.year, date.month, date.day, (Time.zone.now + 3600).hour, 0)
    else
      Time.zone.local(date.year, date.month, date.day, Time.zone.now.hour, _min)
    end
  end

  def time_format_from_task(task)
    if task.to_hours > 0
      task.to_minutes == 0 ? "#{task.to_hours}#{t :hours}" : "#{task.to_hours}#{t :hours}#{task.to_minutes}#{t :minutes}"
    else
      "#{task.to_minutes}#{t :minutes}"
    end
  end

  def total_time_from_tasks(tasks, date)
    times = take_hours_and_minutes(tasks, date)
    time_format(times[:hours], times[:minutes])
  end

  def time_format(hours, minutes)
    if hours > 0
      minutes == 0 ? "#{hours}#{t :hours}" : "#{hours}#{t :hours}#{minutes}#{t :minutes}"
    else
      "#{minutes}#{t :minutes}"
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
