require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  def setup
    @tag = tags(:tag1)
  end

  test 'passes validation' do
    goal = @tag.build_goal(time: '01:00:00')
    assert goal.save
  end

  test 'fails validation' do
    #目標時間が設定されていない
    goal = @tag.build_goal
    refute goal.save

    # 目標時間が0分である
    goal = @tag.build_goal(time: '00:00:00')
    refute goal.save

    # 目標時間が合計28日以上である
    goal = @tag.build_goal(time: '27 days 23:59:00')
    assert goal.save
    goal = @tag.build_goal(time: '28 days 00:00:00')
    refute goal.save
  end

  test 'set_goal_time' do
    goal = Goal.new
    goal.set_goal_time(12, 0)
    assert_equal '0 12:0:00', goal.time
    goal.set_goal_time(36, 0)
    assert_equal '1 12:0:00', goal.time
    goal.set_goal_time(0, 30)
    assert_equal '0 0:30:00', goal.time
  end
end
