class Public::TagsController < ApplicationController
  def index
    @tags = Tag.where(is_active: true).order(name: "ASC")
  end
end
