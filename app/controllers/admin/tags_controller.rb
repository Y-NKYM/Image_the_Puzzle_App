class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tags = Tag.all.page(params[:page]).per(10)
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if@tag.update(tag_params)
      redirect_to admin_tags_path
    else
      render :edit
    end
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
