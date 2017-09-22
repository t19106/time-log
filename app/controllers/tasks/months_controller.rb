class Tasks::MonthsController < ApplicationController
  before_action :verify_user

  def index
    _date = Time.gm(params[:year], params[:month])
    @tasks = Task.where(user: current_user, start_at: _date.beginning_of_month.._date.end_of_month).group_by { |t| t.start_at.day }
    @tasks = @tasks.update((_date.beginning_of_month.day.._date.end_of_month.day).group_by { |t| t }.each { |_k, v| v.clear }) { |_key, val1, _val2| val1 }.sort
  end
end
