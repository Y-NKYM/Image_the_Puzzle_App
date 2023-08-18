class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(' ')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].gsub("　", " ").split(nil)
    if @post.update(post_params)
      @post.get_tag(tag_list)
      redirect_to admin_post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.delete
    redirect_to admin_posts_path
  end

  private
  def post_params
    params.require(:post).permit(:post_image, :title, :content, :is_public, :is_active)
  end
end
