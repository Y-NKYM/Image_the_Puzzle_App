class Public::BookmarksController < ApplicationController
  def index
  end

  def create
    @post = Post.find(params[:post_id])
  	bookmark = current_user.bookmarks.new(post_id: @post.id)
  	bookmark.save
  	redirect_back(fallback_location: root_path)
  end

  def destroy
    @post = Post.find(params[:post_id])
  	bookmark = current_user.bookmarks.find_by(post_id: @post.id)
  	bookmark.destroy
  	redirect_back(fallback_location: root_path)
  end
end
