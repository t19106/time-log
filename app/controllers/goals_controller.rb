class GoalsController < ApplicationController
  before_action :set_goal, only: %i(edit update destroy)

  def new
    @tag = Tag.find(params[:tag_id])
    @goal = @tag.build_goal
  end

  def create
    tag = Tag.find(params[:tag_id])
    goal = tag.build_goal
    goal.time = set_goal_time
    if goal.save
      redirect_to tags_path
    else
      flash[:notice] = goal.errors
      redirect_to tags_path
    end
  end

  def edit
    @tag = Tag.find(@goal.tag.id)
  end

  def update
    @goal.time = set_goal_time
    if @goal.save
      redirect_to tags_path
    else
      flash[:notice] = goal.errors
      redirect_to tags_path
    end
  end

  def destroy
    @goal.destroy
    redirect_to tags_path
  end

  private

    def set_goal
      @goal = Goal.find_by(id: params[:id])
    end

    def set_goal_time
      if params[:hours]
        days = (params[:hours].to_i / 24).to_i
        hours = (params[:hours].to_i % 24).to_i
      else
        days, hours = 0, 0
      end
      mins = params[:minutes].to_i || 0
      "#{days} #{hours}:#{mins}:00"
    end
end
