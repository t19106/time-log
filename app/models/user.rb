class User < ApplicationRecord
  has_many :tasks
  has_secure_password

  validates :mail, presence: true, uniqueness: true

  def login?
    persisted?
  end
end
