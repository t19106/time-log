class Tasks::DaysController < ApplicationController
  include ParameterDatetime
  before_action :verify_user, :validate_date_uri

  def index
    @tasks = Task.tasks_by_date(params_datetime, current_user)
    @task  = Task.new
  end
end
