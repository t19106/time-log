class TasksController < ApplicationController
  before_action :verify_user

  def create
    _date = Time.new(params[:task][:year], params[:task][:month], params[:task][:day])
    task = Task.new(task_params)
    task.start_at = task.start_at.change(year: params[:task][:year], month: params[:task][:month], day: params[:task][:day])
    task.end_at = task.end_at.change(year: params[:task][:year], month: params[:task][:month], day: params[:task][:day])
    task.user = current_user

    if task.save!
      @tasks = Task.where(user: current_user, start_at: task.start_at.beginning_of_day..task.start_at.end_of_day)
      redirect_to tasks_days_path year: task.start_at.year, month: task.start_at.month, day: task.start_at.day
    else
      redirect_to tasks_months_path year: task.start_at.year, month: task.start_at.month
    end
  end

  private

    def task_params
      params.require(:task).permit(:title, :start_at, :end_at)
    end
end
