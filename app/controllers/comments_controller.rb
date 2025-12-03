class CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
  end

  def new; end

  def create
    post = Post.find(params[:comment][:post_id])
    @comment = post.comments.new(comment_params)
    @comment.author = current_user

    if @comment.save # TODO: filter if the user doesnt have rights to comment
      redirect_to post
    else
      render post, status: :unprocessable_entity # TODO: warning message and keep body
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])

    if @comment.update(comment_params)
      render @comment
    else
      flash.now[:alert] = @comment.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def comment_params
    params.expect(comment: [:body])
  end
end
