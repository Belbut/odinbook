class PostsController < ApplicationController
  include AuthorizesContentAccess
  include PreventDeletedContentAccess

  before_action :authorizes_content_access, only: %i[index show]
  before_action :prevent_deleted_content_access, only: %i[edit update destroy]

  def index
    author = User.includes(:posts).find(user_params)

    @posts = author.posts.active.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(commentable: @post, author: current_user)
  end

  def new
    @post = current_user.posts.new(category: :feed) # default post is feed
  end

  def create
    @post = current_user.posts.new(post_params)

    post_category = params[:post][:category].to_sym
    added_files = params[:post][:added_files]

    @post.attach_files(added_files, post_category)

    if @post.save
      redirect_when_success(post_category)
    else
      flash[:alert] = @post.all_errors.to_sentence
      render_when_failed(post_category)
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
  def user_params
    params.expect(:user_id)
  end

  def post_params
    params.expect(post: %i[category body])
  end

  def redirect_when_success(category)
    case category
    when :feed
      redirect_to @post
    when :avatar_selection, :background_selection
      redirect_to current_user.profile
    end
  end

  def render_when_failed(category)
    case category
    when :feed
      render :new, status: :unprocessable_entity
    when :avatar_selection
      render "profiles/change_avatar", status: :unprocessable_entity
      @avatar_attachments = Attachment.includes(post: :author).where(users: { id: current_user },
                                                                 post: { category: :avatar_selection })
    when :background_selection
      @background_attachments = Attachment.includes(post: :author).where(users: { id: current_user },
      post: { category: :background_selection })
      render "profiles/change_background", status: :unprocessable_entity
    end
  end
end
