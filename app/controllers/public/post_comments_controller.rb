class Public::PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comments = @post.post_comments
  	comment = PostComment.new(post_comment_params)
  	comment.user_id = current_user.id
  	comment.post_id = @post.id
  	comment.save
  	render :create
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
