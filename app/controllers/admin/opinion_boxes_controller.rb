class Admin::OpinionBoxesController < ApplicationController
  def index
    range = params[:range]
    case range
    when 'unread'
      @opinion_boxes = OpinionBox.where(is_read: false).page(params[:page])
    when 'read'
      @opinion_boxes = OpinionBox.where(is_read: true).page(params[:page])
    when "all"
      @opinion_boxes = OpinionBox.all.page(params[:page])
    else
      @opinion_boxes = OpinionBox.all.page(params[:page])
    end
  end

  def show
    @opinion_box = OpinionBox.find(params[:id])
  end

  def read
    opinion_box = OpinionBox.find(params[:opinion_box_id])
    opinion_box.update(is_read: true)
    redirect_back(fallback_location: root_path)
  end

  def unread
    opinion_box = OpinionBox.find(params[:opinion_box_id])
    opinion_box.update(is_read: false)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    opinion_box = OpinionBox.find(params[:id])
    opinion_box.delete
    redirect_to admin_opinion_boxes_path(range: "all")
  end

  private
  def opinion_params
  	params.require(:opinion_box).permit(:title, :content)
  end
end
