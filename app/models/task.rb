class Task < ApplicationRecord
  belongs_to :user
  has_one :tags

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ended_after_started
  validate :started_and_ended_are_different
  validate :less_than_a_day
  validate :tasks_not_overlapping

  def ended_after_started
    return if starts_at.nil? || ends_at.nil?
    if starts_at > ends_at
      errors.add(:ends_at, '終了時間は開始時間より前に設定できません。')
    end
  end

  def started_and_ended_are_different
    return if starts_at.nil? || ends_at.nil?
    if starts_at == ends_at
      errors.add(:ends_at, '開始時間と終了時間が同じです。0分以上の作業時間を登録しましょう。')
    end
  end

  def less_than_a_day
    return if starts_at.nil? || ends_at.nil?
    unless to_hours < 24
      errors.add(:ends_at, '24時間を超えるタスクは設定できません。')
    end
  end

  def tasks_not_overlapping
    return if starts_at.nil? || ends_at.nil?
    tasks = Task.where(user: user_id, starts_at: self.starts_at.beginning_of_day..self.starts_at.end_of_day).or(Task.where(user: user_id, ends_at: self.ends_at.beginning_of_day..self.ends_at.end_of_day)).map { |task| task.adjust_overnight_range(self.starts_at) }
    tasks.each do |task|
      if (task.starts_at..task.ends_at).cover?(self.starts_at) || (task.starts_at..task.ends_at).cover?(self.ends_at) || (self.starts_at..self.ends_at).cover?(task.starts_at) || (self.starts_at..self.ends_at).cover?(task.ends_at)
        unless task.starts_at == self.ends_at || task.ends_at == self.starts_at
          errors.add(:ends_at, '他のタスクと時間が重複しています。')
        end
      end
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
