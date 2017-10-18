class Goal < ApplicationRecord
  belongs_to :tag
  validates :time, presence: true
  validate :less_than_a_month

  SECONDS_IN_28DAYS = 2419200

  def less_than_a_month
  end
end
