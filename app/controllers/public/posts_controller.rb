class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].gsub("　", " ").split(nil)
    if @post.save
      @post.get_tag(tag_list)
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def index
    if params[:search] == nil
      @posts = Post.where(is_public: true).order(created_at: "DESC")
    elsif params[:search] == ""
      @posts = nil
    else
      @search = params[:search]
      @posts = Post.where("title LIKE ?", "%#{@search}%").order(created_at: "DESC")
    end
  end

  def show
    @post = Post.find(params[:id])
    @user_posts = @post.user.posts.where.not(id: @post.id).order(created_at: "DESC").limit(6)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post.id)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:post_image, :title, :content, :is_public)
  end

  def is_matching_login_user
    @post = Post.find(params[:id])
    user = User.find(@post.user_id)
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end
end
