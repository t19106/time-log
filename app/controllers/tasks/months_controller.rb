class Tasks::MonthsController < ApplicationController
  before_action :verify_user

  def index
    @date = Time.new(params[:year], params[:month])
    tasks_by_start = Task.where(user: current_user, start_at: @date.beginning_of_month..@date.end_of_month).map { |task| task.adjust_overnight_range(task.start_at) }.group_by { |t| t.start_at.day }
    tasks_by_end = Task.where(user: current_user, end_at: @date.beginning_of_month..@date.end_of_month).map { |task| task.adjust_overnight_range(task.end_at) }.group_by { |t| t.end_at.day }
    @tasks = tasks_by_start.merge(tasks_by_end) { |_k, v1, v2| v1.concat(v2).uniq.sort_by { |t| t.start_at } }
  end
end
