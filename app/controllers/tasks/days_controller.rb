class Tasks::DaysController < ApplicationController
  before_action :verify_user

  def index
    _date = Time.gm(params[:year], params[:month], params[:day])
    @task = Task.find_by(user: current_user, date: _date) || Task.new(user: current_user, date: _date)
    @subtask = Subtask.where(task: @task)
  end
end
