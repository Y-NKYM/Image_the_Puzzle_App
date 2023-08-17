class Public::PostsController < ApplicationController
  before_action :ensure_guest_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!
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
    order = params[:order]
    # 検索なし＝投稿一覧画面
    if params[:search] == nil && params[:tag] == nil
      @posts = Post.where(is_public: true)
      @posts = order_posts(@posts, order)
    # 検索記述無し＝投稿タイトル検索画面
    elsif params[:search] == ""
      @posts = nil
    # 投稿タイトル検索画面
    elsif params[:search]
      @search = params[:search]
      @posts = Post.where("title LIKE ?", "%#{@search}%")
      @posts = order_posts(@posts, order)
    # 検索記述無し＝タグ検索画面
    elsif params[:tag] == ""
      @posts = Post.where(is_public: true)
      @posts = order_posts(@posts, order)
      flash[:notice] = "タグが存在しません。"
    # タグ検索画面
    elsif params[:tag]
      @tag = Tag.find_by(name: params[:tag])
      @posts = @tag.posts
      @posts = order_posts(@posts, order)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user_posts = @post.user.posts.where.not(id: @post.id).order(created_at: "DESC").limit(6)
    @post_tags = @post.tags.where(is_active: true)
    @post_comment = PostComment.new
    @comments = @post.post_comments
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

  def puzzle
    @post = Post.find(params[:post_id])
    unless PostAccess.where(created_at: Time.zone.now.all_day).find_by(post_id: @post.id, user_id: current_user.id)
    current_user.post_accesses.create(post_id: @post.id)
    end
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

  def ensure_guest_user
    @user = User.find(current_user.id)
    if @user.email == "guest@example.com"
      redirect_to posts_path, notice: "ゲストユーザーは使用できないページです。ログインしてください。"
    end
  end

  def order_posts(posts, order)
    case order
    when nil then
      @posts = posts.order(created_at: "DESC").page(params[:page])
    when 'new'
      @posts = posts.order(created_at: "DESC").page(params[:page])
    when 'old'
      @posts = posts.order(created_at: "ASC").page(params[:page])
    when "bookmarks"
      @posts = posts.includes(:bookmarks).sort_by {|x| x.bookmarks.size}.reverse
      @posts = Kaminari.paginate_array(@posts).page(params[:page])
    when "access"
      @posts = posts.includes(:post_accesses).sort_by {|x| x.post_accesses.size}.reverse
      @posts = Kaminari.paginate_array(@posts).page(params[:page])
    else
      @posts = posts.page(params[:page])
    end
  end
end
