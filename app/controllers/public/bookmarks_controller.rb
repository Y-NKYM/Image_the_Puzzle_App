class Public::BookmarksController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @bookmarks = @user.bookmark_posts.page(params[:page])
  end

  def create
    @post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.new(post_id: @post.id)
    if Bookmark.exists?(post_id: @post.id, user_id: current_user.id)
      render :create
    else
      bookmark.save
      render :create
    end

  end

  def destroy
    @post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.find_by(post_id: @post.id)
    unless bookmark == nil
      bookmark.destroy
      render :destroy
    else
      render :destroy
    end

  end
end
