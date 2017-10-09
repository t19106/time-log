require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @mail = 'test01@example.com'
    @password = 'test'
    @fake_password = 'fake'
  end

  test 'passes validation' do
    user = User.new(mail: @mail, password: @password)
    assert user.save
  end

  test 'fails validation' do
    user = User.new(password: @password)
    refute user.save

    user = User.new(mail: @mail)
    refute user.save

    user = User.new(mail: @user1.mail, password: @password)
    refute user.save
  end

  test 'login?' do
    assert users(:user1).login?
    refute User.new.login?
  end
end
