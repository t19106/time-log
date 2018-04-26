class Tasks::MonthsController < ApplicationController
  include ParameterDatetime
  before_action :verify_user, :validate_date_uri

  def index
    @tasks = tasks_by_month
  end

  private

  def tasks_by_month
    relation = Task::Relation.new(params_datetime, current_user)
    relation.tasks_by_month
  end
end
