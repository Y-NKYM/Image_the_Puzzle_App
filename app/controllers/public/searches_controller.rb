class Public::SearchesController < ApplicationController
  def index
    @post = Post.last
  end
end
