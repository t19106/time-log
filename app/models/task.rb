class Task < ApplicationRecord
  belongs_to :user
  has_many :subtasks

  def to_hours
    ((end_at - start_at) / 60 / 60).to_i
  end

  def to_minutes
    (((end_at - start_at) / 60) % 60).to_i
  end

  def is_overnight?
    start_at.day != end_at.day
  end

  def adjust_overnight_range(date)
    _task = self.dup
    if start_at < date.beginning_of_day
      _task.start_at = _task.start_at.change(day: date.day, hour: 0, min: 0)
    elsif end_at > date.end_of_day
      _task.end_at = _task.end_at.change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    _task
  end
end
