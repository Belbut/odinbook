class PostsController < ApplicationController
  before_action :limit_deleted_usage, only: %i[edit update destroy]
  def index
    author = User.includes(:posts).find(user_params)

    @posts = author.posts.active.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(commentable: @post, author: current_user)
  end

  def new
    @content = Content.new_with_post(author: current_user, category: :feed)
  end

  def create
    @content = Content.new_with_post(author: current_user, **post_content_params)
    @content.post.attach_files(attachments_params)

    if @content.save
      case @content.post.category.to_sym
      when :feed
        redirect_to @content.post
      when :avatar_selection, :background_selection
        redirect_to user_profile_path(current_user)
      end
    else
      render :new, status: :unprocessable_entity, notice: @content.post.errors.full_messages
    end
  end

  def edit
    @content = Content.posts.find_by(contentable_id: params[:id])
  end

  def update
    @content = Content.posts.find_by(contentable_id: params[:id])

    @content.post.attach_files(attachments_params)
    require "pry-byebug"
    binding.pry

    @content.update!(post_content_params)
    redirect_to @content.post
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

  def attachments_params
    params.expect(content: [contentable_attributes: [attachments: []]])
          .dig(:contentable_attributes, :attachments)
  end

  def post_content_params
    params.expect(content: [:body, { contentable_attributes: [:category] }])
  end
end
