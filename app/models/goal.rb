class Goal < ApplicationRecord
  belongs_to :tag
  validates :time, presence: true
  validate :less_than_a_month

  HOURS_IN_MONTH = 730

  def less_than_a_month
    if time.to_i > HOURS_IN_MONTH
      errors.add(:time, '一ヶ月を超える期間を、目標時間として設定できません。')
    end
  end
end
