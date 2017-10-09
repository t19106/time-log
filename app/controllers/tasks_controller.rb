class TasksController < ApplicationController
  before_action :verify_user

  def create
    _date = Time.zone.local(params[:task][:year], params[:task][:month], params[:task][:day])
    task = Task.new(task_params)
    task.user = current_user

    if task.save
      @tasks = Task.where(user: current_user, starts_at: task.starts_at.beginning_of_day..task.starts_at.end_of_day)
      redirect_to tasks_days_path year: task.starts_at.year, month: task.starts_at.month, day: task.starts_at.day
    else
      flash[:notice] = task.errors
      redirect_to tasks_days_path year: task.starts_at.year, month: task.starts_at.month, day: task.starts_at.day
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    date = params[:date].to_datetime
    redirect_to tasks_days_path year: date.year, month: date.month, day: date.day
  end

  private

    def task_params
      params.require(:task).permit(:memo, :starts_at, :ends_at)
    end
end
