require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @time = Time.zone.now
  end

  test 'passes validation' do
    task = Task.new(user: @user, starts_at: @time, ends_at: @time + (60 * 60))
    assert task.save
  end

  test 'fails validation' do
    # 時間情報が不足している（両方、あるいはどちらかしか存在しない）
    task = Task.new(user: @user), Task.new(user: @user, starts_at: @time), Task.new(user: @user, ends_at: @time)
    task.each { |t| refute t.save }

    # ends_atが先に始まる
    task = Task.new(user: @user, starts_at: @time + (60 * 60), ends_at: @time)
    refute task.save

    # starts_atとends_atが同じ
    task = Task.new(user: @user, starts_at: @time, ends_at: @time)
    refute task.save

    # 作業時間が24時間を超える
    task = Task.new(user: @user, starts_at: @time, ends_at: @time.tomorrow + 1)
    refute task.save

    # 作業時間が24時間ちょうどである
    task = Task.new(user: @user, starts_at: @time, ends_at: @time.tomorrow)
    refute task.save
  end
end
