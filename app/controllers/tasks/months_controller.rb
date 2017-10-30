class Tasks::MonthsController < ApplicationController
  include ParameterDatetime
  before_action :verify_user, :validate_date_uri

  def index
    @tasks = Task.tasks_by_month(params_datetime, current_user)
  end
end
