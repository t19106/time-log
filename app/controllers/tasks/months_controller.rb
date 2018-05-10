class Tasks::MonthsController < ApplicationController
  include ParameterDatetime
  before_action :verify_user, :validate_date_uri

  def index
    set_tasks_by_month
    set_goal_times_achievements if @tasks.values
  end

  private

  def set_tasks_by_month
    relation = Task::Relation.new(params_datetime, current_user)
    @tasks = relation.tasks_by_month
  end

  def set_goal_times_achievements
    @goals = {}
    @achievements = {}
    @tasks.values.each do |array|
      array.each do |task|
        next unless task.tag_id
        tag = Tag.find(task.tag_id)
        next unless tag
        @goals[tag.name] ||= tag.goal.to_seconds if tag.goal
        if @achievements[tag.name]
          @achievements[tag.name] += task.to_seconds
        else
          @achievements[tag.name] ||= task.to_seconds
        end
      end
    end
  end
end
