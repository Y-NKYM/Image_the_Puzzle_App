class Public::TagsController < ApplicationController
  def index
    @tags = Tag.order(name: "ASC")
    @tag_search = params[:tag_search]
  end
end
