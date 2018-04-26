class Goal < ApplicationRecord
  belongs_to :tag
  validates :time, presence: true
  validate :is_not_zero_minute
  validate :less_than_a_month

  SECONDS_IN_28DAYS = 2419200

  def is_not_zero_minute
    return unless time
    errors.add(:time, '毎月の目標時間を、0分に設定することはできません。') if to_seconds == 0
  end

  def less_than_a_month
    return unless time
    errors.add(:time, '毎月の目標時間を、合計28日以上に設定することはできません。') if to_seconds >= SECONDS_IN_28DAYS
  end

  def to_seconds
    return unless time
    Goals::IntervalParser.new(time).to_seconds
  end

  def set_goal_time(hours, minutes)
    if hours.to_i > 0
      days  = (hours.to_i / 24).to_i
      hours = (hours.to_i % 24).to_i
    else
      days  = 0
      hours = 0
    end
    mins = minutes.to_i || 0
    self.time = "#{days} #{hours}:#{mins}:00"
  end
end
