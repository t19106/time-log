require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  def setup
    @tag = tags(:tag1)
  end

  test 'passes validation' do
    goal = @tag.build_goal(time: "01:00:00")
    assert goal.save
  end

  test 'fails validation' do
    goal = @tag.build_goal(time: "731:00:00")
    refute goal.save
  end
end
