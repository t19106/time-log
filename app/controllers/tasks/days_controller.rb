class Tasks::DaysController < ApplicationController
  before_action :verify_user, :validate_uri

  def index
    @tasks = Task.tasks_by_date(@date, current_user)
    @task  = Task.new
  end
end
