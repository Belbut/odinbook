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
    shared_files = params[:post][:files]

    shared_files.each do |file|
      img = Image.new(file: file)
      @post.attachments.build(annexable: img)
    end

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
    params.expect(post: %i[body])
  end
end
