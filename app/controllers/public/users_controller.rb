class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, except: [:show]

  def index
    @user = User.find(current_user.id)
  end

  def mypage
    @user = User.find(current_user.id)
    @posts = @user.posts.limit(4)
    @bookmarks = @user.bookmark_posts.limit(4)
  end

  def show
    @user = User.find(params[:id])
    @posts_all = @user.posts.all
    @posts_public = @user.posts.where(is_public: true)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    user = User.find(current_user.id)
    user.update(user_params)
    redirect_to users_mypage_path, notice: "アカウント情報を編集しました。"
  end

  def withdraw
    user = User.find(current_user.id)
    user.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "正常に退会いたしました。"
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to posts_path, notice: "ゲストでログインしました。"
  end

  private

  def user_params
  params.require(:user).permit(:name, :email, :introduction)
  end

  def ensure_guest_user
    @user = User.find(current_user.id)
    if @user.email == "guest@example.com"
      redirect_to posts_path, notice: "ゲストユーザーは使用できないページです。ログインしてください。"
    end
  end

end
