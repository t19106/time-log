class User < ApplicationRecord
  has_many :tasks
  has_secure_password

  validates :mail, uniqueness: true

  def login?
    persisted?
  end
end
