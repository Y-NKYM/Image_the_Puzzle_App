class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user

  def index
    @user = User.find(current_user.id)
    @bookmarks = @user.bookmark_posts.where(is_active: true).where(is_public: true).order(created_at: "DESC").page(params[:page])
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

  private

  def ensure_guest_user
    @user = User.find(current_user.id)
    if @user.email == "guest@example.com"
      redirect_to posts_path, notice: "ゲストユーザーは使用できないページです。ログインしてください。"
    end
  end

end
