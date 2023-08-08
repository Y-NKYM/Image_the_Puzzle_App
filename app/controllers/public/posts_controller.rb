class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
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
    # 検索なし＝投稿一覧画面
    if params[:search] == nil && params[:tag] == nil
      @posts = Post.where(is_public: true).order(created_at: "DESC").page(params[:page])
    # 検索記述無し＝投稿タイトル検索画面
    elsif params[:search] == ""
      @posts = nil
    # 投稿タイトル検索画面
    elsif params[:search]
      @search = params[:search]
      @posts = Post.where("title LIKE ?", "%#{@search}%").order(created_at: "DESC").page(params[:page])
    # 検索記述無し＝タグ検索画面
    elsif params[:tag] == ""
      @posts = Post.where(is_public: true).order(created_at: "DESC").page(params[:page])
      flash[:notice] = "タグが存在しません。"
    # タグ検索画面
    elsif params[:tag]
      @tag = Tag.find_by(name: params[:tag])
      @posts = @tag.posts.order(created_at: "DESC").page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @user_posts = @post.user.posts.where.not(id: @post.id).order(created_at: "DESC").limit(6)
    @post_tags = @post.tags.where(is_active: true)
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.where(is_active: true).pluck(:name).join(' ')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].gsub("　", " ").split(nil)
    if @post.update(post_params)
      @post.get_tag(tag_list)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
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
