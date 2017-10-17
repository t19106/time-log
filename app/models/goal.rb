class Goal < ApplicationRecord
  belongs_to :tag
  validates :time, presence: true
  validate :less_than_a_month

  SECONDS_IN_28DAYS = 2419200

  def less_than_a_month
    if ((Time.zone.parse(time).beginning_of_day)..(Time.zone.parse(time).beginning_of_day + SECONDS_IN_28DAYS)).cover?(Time.zone.parse(time))
      errors.add(:time, '一ヶ月を超える期間を、目標時間として設定できません。')
    end
  end
end
