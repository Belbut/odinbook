class PostsController < ApplicationController
  def index
    @author = User.find(user_params)
    @author_profile = @author.profile
    @posts = @author.posts
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def user_params
    params.expect(:user_id)
  end

  def post_params
    params.expect(:id)
  end
end
