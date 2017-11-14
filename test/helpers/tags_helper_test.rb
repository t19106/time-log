require 'test_helper'

class TagsHelperTest < ActiveSupport::TestCase
  include TagsHelper

  def setup
    @user = users(:user1)
    @goal = goals(:goal1)
  end

  test 'goal_time_to_total' do
    assert_equal '36時間', goal_time_to_total(@goal)

    @goal.time = '1 day 12:30:00'
    assert_equal '36時間30分', goal_time_to_total(@goal)
  end
end
