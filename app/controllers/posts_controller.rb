class PostsController < ApplicationController
  before_action :limit_deleted_usage, only: %i[edit update destroy]
  def index
    author = User.find(user_params)
    @posts = author.posts
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(commentable: @post, author: current_user)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    added_files = params[:post][:added_files]
    @post.attach_files(added_files)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    added_files = params[:post][:added_files]
    @post.attach_files(added_files)

    @post.update(post_params)
    redirect_to @post
  end

  def destroy
    @post = current_user.posts.find(params[:id])

    if @post.update(deleted: true)
      flash[:alert] = "The post deleted, but the thread is still alive"
      redirect_to @post
    else
      flash.now[:alert] = @post.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def limit_deleted_usage
    @post = current_user.posts.find(params[:id])

    return unless @post.deleted?

    redirect_to @post
  end

  def user_params
    params.expect(:user_id)
  end

  def post_params
    params.expect(post: %i[body])
  end
end
