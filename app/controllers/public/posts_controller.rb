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
    @posts = Post.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
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
