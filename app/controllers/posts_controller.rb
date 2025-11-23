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

    @post.destroy
    redirect_to user_posts_path(current_user)
  end

  private

  def user_params
    params.expect(:user_id)
  end

  def post_params
    params.expect(post: %i[body])
  end
end
