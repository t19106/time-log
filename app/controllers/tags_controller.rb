class TagsController < ApplicationController
  before_action :set_tag, only: %i(edit update destroy)

  def index
    @tags = current_user.tags.all
  end

  def new
    @tag = Tag.new
  end

  def create
    tag = current_user.tags.build(tag_params)
    if tag.save
      redirect_to tags_path
    else
      flash[:notice] = tag.errors
      redirect_to new_tag_path
    end
  end

  def edit
  end

  def update
    if @tag.update_attributes(tag_params)
      redirect_to tags_path
    else
      flash[:notice] = @tag.errors
      redirect_to edit_tag_path
    end
  end

  def destroy
    Task.where(tag_id: @tag).map do |task|
      task.tag_id = nil
      task.save!(validate: false)
    end
    @tag.destroy
    redirect_to tags_path
  end

  private

  def set_tag
    @tag = current_user.tags.find_by(id: params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
