class CommentsController < ApplicationController
  before_action :limit_deleted_usage, only: %i[edit update destroy]
  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = parent_content.replies.new(author: current_user)
  end

  def create
    parent_content = parent_content(params[:comment])
    @comment = parent_content.replies.new(comment_params)
    @comment.author = current_user

    if @comment.save # TODO: filter if the user doesnt have rights to comment
      redirect_to parent_content
    else
      render parent_content, status: :unprocessable_entity # TODO: warning message and keep body
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])

    if @comment.update(comment_params)
      redirect_to @comment
    else
      flash.now[:alert] = @comment.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.update(deleted: true)

    redirect_to @comment
  end

  private

  def comment_params
    params.expect(comment: [:body])
  end

  def limit_deleted_usage
    @comment = current_user.comments.find(params[:id])

    return unless @comment.deleted?

    redirect_to @comment, status: :unprocessable_entity
  end

  # def parent_content
  #   return Comment.find(params[:comment_id]) if params.dig(:comment_id)
  #   return Comment.find(params[:comment][:comment_id]) if params.dig(:comment, :comment_id)
  #   return Post.find(params[:post_id]) if params.dig(:post_id)
  #   return Post.find(params[:comment][:post_id]) if params.dig(:comment, :post_id)

  #   raise "error"
  # end

  def parent_content(params = request.params)
    return Comment.find(params[:comment_id]) if params[:comment_id]
    return Post.find(params[:post_id]) if params[:post_id]

    raise "error"
  end
end
