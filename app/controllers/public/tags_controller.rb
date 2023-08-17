class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  def index
    @tags = Tag.where(is_active: true).order(name: "ASC")
  end
end
