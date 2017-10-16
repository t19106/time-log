class Tag < ApplicationRecord
  belongs_to :user
  has_one :goal, dependent: :destroy
end
