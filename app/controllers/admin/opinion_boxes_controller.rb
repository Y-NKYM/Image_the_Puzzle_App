class Admin::OpinionBoxesController < ApplicationController
  def index
    @opinion_box = OpinionBox.all
  end

  def show
    @opinion_box = OpinionBox.find(params[:id])
  end

  def edit
    @opinion_box = OpinionBox.find(params[:id])
  end

  def update
    opinion_box = OpinionBox.find(params[:id])
    opinion_box.update(opinion_params)
    redirect_to admin_opinion_box_path
  end

  def destroy
    opinion_box = OpinionBox.find(params[:id])
    opinion_box.delete
    redirect_to admin_opinion_boxes_path
  end

  private
  def opinion_params
  	params.require(:opinion_box).permit(:title, :content)
  end
end
