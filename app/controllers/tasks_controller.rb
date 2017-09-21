class TasksController < ApplicationController
  before_action :verify_user

  def index
    criterion = Time.gm(params[:year], params[:month])
    last_day = criterion.end_of_month.day
    _tasks = Task.where(user: current_user, date: criterion.beginning_of_month..criterion.end_of_month).group_by { |t| t.date.day }
    @tasks = []
    (1..last_day).each do |day|
      _tasks[day] ? @tasks << _tasks[day].first : @tasks << Task.new(user: current_user, date: criterion.change(day: day))
    end
  end
end
