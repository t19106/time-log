class TasksController < ApplicationController
  before_action :verify_user

  def create
    _date = Time.gm(params[:subtask][:year], params[:subtask][:month], params[:subtask][:day])
    task = Task.find_by(user: current_user, date: _date) || Task.create(user: current_user, date: _date)
    subtask = Subtask.new(subtask_params)
    subtask.task = task

    if subtask.save!
      @task = task
      @subtask = Subtask.where(task: task)
      redirect_to tasks_days_path year: task.date.year, month: task.date.month, day: task.date.day
    else
      redirect_to controller: :tasks, action: :month, year: task.date.year, month: task.date.month
    end
  end

  private

    def subtask_params
      params.require(:subtask).permit(:time, :title)
    end
end
