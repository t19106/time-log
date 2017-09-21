class SubtasksController < ApplicationController
  def create
    _date = Time.gm(params[:subtask][:year], params[:subtask][:month], params[:subtask][:day])
    task = Task.find_by(user: current_user, date: _date)
    task = Task.create(user: current_user, date: _date) unless task
    subtask = Subtask.new(subtask_params)
    subtask.task = task

    if subtask.save!
      @task = task
      @subtask = Subtask.where(task: task)
      render template: 'tasks/show', year: @task.date.year, month: @task.date.month, day: @task.date.day
    else
      redirect_to controller: :tasks, action: :index, year: params[:task].date.year, month: params[:task].date.month
    end
  end

  private

    def subtask_params
      params.require(:subtask).permit(:time, :title)
    end
end
