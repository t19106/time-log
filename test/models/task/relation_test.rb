require 'test_helper'

class Task::RelationTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @date = Time.zone.local(2017, 10, 1)
  end

  test 'initialize' do
    assert Task::Relation.new(@date, @user)
  end

  test 'tasks_by_month' do
    relation = Task::Relation.new(@date, @user)
    assert_equal 5, relation.tasks_by_month.inject(0) { |total, (_, val)| total + val.count }
  end

  test 'tasks_by_date' do
    relation = Task::Relation.new(@date, @user)
    assert_equal 4, relation.tasks_by_date.count
  end
end
