class Task < ApplicationRecord
  belongs_to :user

  validates :memo, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ended_after_started?
  validate :less_than_a_day?

  def ended_after_started?
    if starts_at >= ends_at
      errors.add(:ends_at, ': 終了時間は開始時間より前に設定できません。')
    end
  end

  def less_than_a_day?
    unless to_hours < 24
      errors.add(:ends_at, ': ２４時間を超えるタスクは設定できません。')
    end
  end

  def to_hours
    ((ends_at - starts_at) / 60 / 60).to_i
  end

  def to_minutes
    (((ends_at - starts_at) / 60) % 60).to_i
  end

  def is_overnight?
    starts_at.day != ends_at.day
  end

  def over_end_of_month?
    starts_at.month != ends_at.month
  end

  def adjust_overnight_range(date)
    return self unless is_overnight?
    _task = self.clone
    if starts_at < date.beginning_of_day
      _task.starts_at = starts_at.change(day: date.day, hour: 0, min: 0)
      _task.starts_at = starts_at.change(month: date.month, day: date.day, hour: 0, min: 0) if over_end_of_month?
    elsif ends_at > date.end_of_day
      _task.ends_at = ends_at.change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    _task
  end
end
