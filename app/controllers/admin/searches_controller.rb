class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @word = params[:word]
    @range = params[:range]
    case @range
    when "ユーザー名"
      @users = User.where("name LIKE ?", "%#{@word}%")
    when "投稿タイトル"
      @posts = Post.where("title LIKE ?", "%#{@word}%")
    when "タグ名"
      @tags = Tag.where("name LIKE ?", "%#{@word}%")
    when "コメント"
      @post_comments = PostComment.where("comment LIKE ?", "%#{@word}%")
    else
      nil
    end
  end
end
