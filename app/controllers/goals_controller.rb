class GoalsController < ApplicationController
  before_action :set_goal, only: %i(edit update destroy)

  def new
    @tag = Tag.find(params[:tag_id])
    @goal = @tag.build_goal
  end

  def create
    goal = Goal.new(goal_params)
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
    if @goal.update_attributes(goal_params)
      redirect_to tags_path
    else
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

    def goal_params
      params.require(:goal).permit(:tag_id, :time)
    end
end
