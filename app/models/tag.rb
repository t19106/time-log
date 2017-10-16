class Tag < ApplicationRecord
  belongs_to :user
  has_one :goal, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
end
