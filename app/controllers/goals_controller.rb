class GoalsController < ApplicationController
  before_action :set_goal, only: %i(edit update destroy)

  def new
    @tag = Tag.find(params[:tag_id])
    @goal = @tag.build_goal
  end

  def create
    tag = Tag.find(params[:tag_id])
    goal = tag.build_goal
    goal.set_goal_time(params[:hours], params[:minutes])
    if goal.save
      redirect_to tags_path
    else
      flash[:notice] = goal.errors
      redirect_to tags_path
    end
  end

  def edit
    @tag = Tag.find(@goal.tag_id)
  end

  def update
    @goal.set_goal_time(params[:hours], params[:minutes])
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
end
