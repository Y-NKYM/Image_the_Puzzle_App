class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update(tag_params)
    redirect_to admin_tags_path
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.delete
    redirect_to admin_tags_path
  end

  private
  def tag_params
    params.require(:tag).permit(:name, :is_active)
  end
end
