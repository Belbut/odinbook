class PostsController < ApplicationController
  def index
    author = User.find(user_params)
    @posts = author.posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def user_params
    params.expect(:user_id)
  end

  def post_params
    params.expect(post: %i[body attachments])
  end
end
