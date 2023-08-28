class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @post_comments = PostComment.all.page(params[:page]).per(10)
  end

  def show
    @post_comment = PostComment.find(params[:id])
  end

  def edit
    @post_comment = PostComment.find(params[:id])
  end

  def update
    @post_comment = PostComment.find(params[:id])
    if @post_comment.update(comment_params)
    redirect_to admin_post_comment_path(@post_comment.id)
    else
      render :edit
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    @post_comment.delete
    redirect_to admin_post_comments_path
  end

  private
  def comment_params
    params.require(:post_comment).permit(:comment, :is_active)
  end
end
