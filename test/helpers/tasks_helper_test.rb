require 'test_helper'

class TasksHelperTest < ActiveSupport::TestCase
  include TasksHelper

  def setup
    @user = users(:user1)
    @date = Time.zone.local(2017, 10, 1)
    @task1 = tasks(:task1)
    @task2 = tasks(:task2)
  end

  test 'show_time_range' do
    assert_equal '12:00 ~ 13:30', show_time_range(@task1)
  end

  test 'set_time_select_to_now' do
    date1 = Time.new(2017, 10, 1, 12, 0, 0)
    assert_equal date1, set_time_select_to_now(date1)
    date2 = Time.new(2017, 10, 1, 12, 59, 0)
    assert_equal Time.new(2017, 10, 1, 13, 0, 0), set_time_select_to_now(date2)
  end

  test 'time_format_from_task' do
    assert_equal '1時間30分', time_format_from_task(@task1)
    assert_equal '30分', time_format_from_task(@task2)
  end

  test 'total_time_from_tasks' do
    relation = Task::Relation.new(@date, @user)
    assert_equal '3時間', total_time_from_tasks(relation.tasks_by_date, Time.now)

    assert_equal '30分', total_time_from_tasks([@task2], Time.now)
  end
end
