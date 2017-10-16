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
      redirect_to tags_path
    end
  end

  def edit
  end

  def update
    if @tag.update_attributes(tag_params)
      redirect_to tags_path
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
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
