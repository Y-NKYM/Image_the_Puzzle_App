class Admin::SearchesController < ApplicationController
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
    else
      nil
    end
  end
end
