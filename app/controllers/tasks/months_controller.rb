class Tasks::MonthsController < ApplicationController
  before_action :verify_user

  def index
    _date = Time.new(params[:year], params[:month])
    _tasks = Task.where(user: current_user, start_at: _date.beginning_of_day.._date.end_of_day).or(Task.where(user: current_user, end_at: _date.beginning_of_day.._date.end_of_day))
    _tasks = _tasks.group_by { |t| t.start_at.day }.update(_tasks.group_by { |t| t.end_at.day }) { |_key, val1, _val2| val1 }
    @tasks = _tasks.update((_date.beginning_of_month.day.._date.end_of_month.day).group_by { |t| t }.each { |_k, v| v.clear }) { |_key, val1, _val2| val1 }.sort
  end
end
