class Task < ApplicationRecord
  belongs_to :user
  has_one :tags

  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :ended_after_started
  validate :started_and_ended_are_different
  validate :less_than_a_day
  validate :tasks_not_overlapping

  def self.tasks_by_month(date, user)
    monthly_tasks_by_starts_at(date, user).merge(monthly_tasks_by_ends_at(date, user)) { |_k, v1, v2| v1.concat(v2).uniq.sort_by { |t| t.starts_at } }
  end

  def self.monthly_tasks_by_starts_at(date, user)
    user.tasks.where(starts_at: date.beginning_of_month..date.end_of_month).map { |task| task.adjust_overnight_range(task.starts_at) }.group_by { |t| t.starts_at.day }
  end

  def self.monthly_tasks_by_ends_at(date, user)
    user.tasks.where(ends_at: date.beginning_of_month..date.end_of_month).map { |task| task.adjust_overnight_range(task.ends_at) }.group_by { |t| t.ends_at.day }
  end

  def self.tasks_by_date(date, user)
    same_day_tasks_by_starts_at(date, user).or(same_day_tasks_by_ends_at(date, user)).map { |task| task.adjust_overnight_range(task.starts_at) }.sort_by { |t| t.starts_at }
  end

  def self.same_day_tasks_by_starts_at(date, user)
    user.tasks.where(starts_at: date.beginning_of_day..date.end_of_day)
  end

  def self.same_day_tasks_by_ends_at(date, user)
    user.tasks.where(ends_at: date.beginning_of_day..date.end_of_day)
  end

  def to_hours
    ((ends_at - starts_at) / 1.hour.to_i).to_i
  end

  def to_minutes
    (((ends_at - starts_at) / 1.minute.to_i) % 1.minute.to_i).to_i
  end

  def adjust_overnight_range(date)
    return self unless overnight?
    if started_yesterday?(date)
      if over_end_of_month?
        self.starts_at = self.starts_at.change(month: date.month, day: date.day, hour: 0, min: 0)
      else
        self.starts_at = self.starts_at.change(day: date.day, hour: 0, min: 0)
      end
    elsif ends_tomorrow?(date)
      self.ends_at = self.ends_at.change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    self
  end

  private

  def ended_after_started
    return unless time_set?
    errors.add(:ends_at, '終了時間は開始時間より前に設定できません。') if starts_at > ends_at
  end

  def started_and_ended_are_different
    return unless time_set?
    errors.add(:ends_at, '開始時間と終了時間が同じです。0分以上の作業時間を登録しましょう。') if starts_at == ends_at
  end

  def less_than_a_day
    return unless time_set?
    errors.add(:ends_at, '24時間を超えるタスクは設定できません。') unless to_hours < 24
  end

  def tasks_not_overlapping
    return unless time_set?
    user = User.find(user_id)
    Task.tasks_by_date(starts_at, user).each do |task|
      next unless overlapping?(task)
      errors.add(:ends_at, '他のタスクと時間が重複しています。') unless tasks_side_by_side?(task)
    end
  end

  def time_set?
    starts_at && ends_at
  end

  def overnight?
    starts_at.day != ends_at.day
  end

  def over_end_of_month?
    starts_at.month != ends_at.month
  end

  def started_yesterday?(date)
    starts_at < date.beginning_of_day
  end

  def ends_tomorrow?(date)
    ends_at > date.end_of_day
  end

  def overlapping?(task)
    surrounded_by_task?(task) || surrounds_the_task?(task)
  end

  def surrounded_by_task?(task)
    (task.starts_at..task.ends_at).cover?(self.starts_at) || (task.starts_at..task.ends_at).cover?(self.ends_at)
  end

  def surrounds_the_task?(task)
    (self.starts_at..self.ends_at).cover?(task.starts_at) || (self.starts_at..self.ends_at).cover?(task.ends_at)
  end

  def tasks_side_by_side?(task)
    task.starts_at == self.ends_at || task.ends_at == self.starts_at
  end
end
