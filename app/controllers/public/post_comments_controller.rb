class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comments = @post.post_comments
  	@post_comment = PostComment.new(post_comment_params)
  	@post_comment.user_id = current_user.id
  	@post_comment.post_id = @post.id
  	if @post_comment.save
  	  render :create
  	else
  	  render :error
  	end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comments = @post.post_comments
    comment = PostComment.find(params[:id])
    comment.destroy
    render :destroy
  end

  private
  def post_comment_params
  	params.require(:post_comment).permit(:comment)
  end

end
