class TasksController < ApplicationController
  before_action :verify_user

  def create
    task = current_user.tasks.build(task_params)

    if task.save
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
    params.require(:task).permit(:memo, :starts_at, :ends_at, :tag_id)
  end
end
