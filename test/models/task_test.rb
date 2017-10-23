require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @time = Time.zone.parse('12:00')
  end

  test 'passes validation' do
    task = Task.new(user: @user, starts_at: @time, ends_at: @time + 1.hour.to_i)
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

    # 作業時間は重複できない
    # ただし、時間の端（前者終了時間と後者開始時間）は重複しても構わない

    # 軸となるタスク
    main_task = Task.new(user: @user, starts_at: @time, ends_at: @time + 1.hour.to_i)
    assert main_task.save

    # 時間の重複 - すでに存在するタスクと、全く同じ時間で新しいタスクを保存できない
    task = Task.new(user: @user, starts_at: @time, ends_at: @time + 1.hour.to_i) # main_taskと同じ時間
    refute task.save

    # 時間の重複 - すでに存在するタスクを囲うかのように、タスクを保存できない
    # イメージ => (新しい(既存のタスク)タスク)
    task = Task.new(user: @user, starts_at: @time - 1.hour.to_i, ends_at: @time + 2.hours.to_i)
    refute task.save

    # 前後一時間の保存
    # 時間の端がちょうど重複する分には問題ない
    task_before = Task.new(user: @user, starts_at: @time - 1.hour.to_i, ends_at: @time)
    assert task_before.save
    task_after = Task.new(user: @user, starts_at: @time + 1.hour.to_i, ends_at: @time + 2.hours.to_i)
    assert task_after.save

    # 時間の重複 - main_task内に時間設定
    task = Task.new(user: @user, starts_at: @time + 20.minutes.to_i, ends_at: @time + 40.minutes.to_i)
    refute task.save
    task = Task.new(user: @user, starts_at: @time + 1, ends_at: @time + 59.minutes.to_i)
    refute task.save

    # 時間の重複 - task_before内に時間設定（afterにしても、同じことをするだけなので割愛）
    task = Task.new(user: @user, starts_at: @time - 1.5.hour.to_i, ends_at: @time - 30.minutes.to_i)
    refute task.save

    # 時間の重複 - 片方がtask_before、もう片方がtask_after内に時間設定
    main_task.delete
    task = Task.new(user: @user, starts_at: @time - 0.5.hour.to_i, ends_at: @time - 1.5.hours.to_i)
    refute task.save
  end
end
