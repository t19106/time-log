class Goal < ApplicationRecord
  belongs_to :tag
  validates :time, presence: true
  validate :is_not_zero_minute
  validate :less_than_a_month

  SECONDS_IN_28DAYS = 2419200

  def is_not_zero_minute
    return unless time
    errors.add(:time, '毎月の目標時間を、0分に設定することはできません。') if in_seconds == 0
  end

  def less_than_a_month
    return unless time
    errors.add(:time, '毎月の目標時間を、合計28日以上に設定することはできません。') if in_seconds >= SECONDS_IN_28DAYS
  end

  def in_seconds
    return unless time
    d_and_t = time =~ /day/ ? time.split(/\s[a-z]{3,4}\s/) : time.split(/\s/)
    if d_and_t[1]
      _time = Time.zone.parse(d_and_t[1]).to_a.take(3).reverse
      return ((d_and_t[0].to_i * 1.day.to_i) + (_time[0].to_i * 1.hour.to_i) + (_time[1].to_i * 1.minute.to_i) + _time[2].to_i)
    else
      _time = Time.zone.parse(d_and_t[0]).to_a.take(3).reverse
      return ((_time[0].to_i * 1.hour.to_i) + (_time[1].to_i * 1.minute.to_i) + _time[2].to_i)
    end
  end

  def set_goal_time(hours, minutes)
    if hours
      days  = (hours.to_i / 24).to_i
      hours = (hours.to_i % 24).to_i
    else
      days, hours = 0, 0
    end
    mins = minutes.to_i || 0
    self.time = "#{days} #{hours}:#{mins}:00"
  end
end
