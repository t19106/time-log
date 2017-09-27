class Tasks::MonthsController < ApplicationController
  before_action :verify_user

  def index
    _date = Time.new(params[:year], params[:month])
    tasks_by_start = Task.where(user: current_user, start_at: _date.beginning_of_month.._date.end_of_month).map { |task| task.adjust_overnight_range(_date) }.group_by { |t| t.start_at.day }
    tasks_by_end = Task.where(user: current_user, end_at: _date.beginning_of_month.._date.end_of_month).map { |task| task.adjust_overnight_range(_date) }.group_by { |t| t.end_at.day }
    @tasks = tasks_by_start.update(tasks_by_end).update((_date.beginning_of_month.day.._date.end_of_month.day).group_by { |t| t }.each { |_k, v| v.clear }) { |_key, val1, _val2| val1 }.sort
  end
end
