class Public::OpinionBoxesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user

  def new
    @opinion_box = OpinionBox.new
  end

  def create
    opinion_box = OpinionBox.new(opinion_params)
    opinion_box.user_id = current_user.id
    if opinion_box.save
      redirect_to users_mypage_path, notice: "ご意見が運営に送られました。"
    else
      @opinion_box = opinion_box
      render :new
    end
  end

  private
  def opinion_params
  	params.require(:opinion_box).permit(:title, :content)
  end

  def ensure_guest_user
    @user = User.find(current_user.id)
    if @user.email == "guest@example.com"
      redirect_to posts_path, notice: "ゲストユーザーは使用できないページです。ログインしてください。"
    end
  end
end
