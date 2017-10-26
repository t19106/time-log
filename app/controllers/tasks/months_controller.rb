class Tasks::MonthsController < ApplicationController
  before_action :verify_user, :validate_uri

  def index
    @tasks = Task.tasks_by_month(@date, current_user)
  end
end
