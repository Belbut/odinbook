class CommentsController < ApplicationController
  include AuthorizesContentAccess
  include PreventDeletedContentAccess

  before_action :authenticate_user!
  before_action :authorizes_content_access, only: %i[show create]
  # before_action :prevent_deleted_content_access, only: %i[edit update destroy]

  def show
    @comment = Comment.find(params[:id])
    # still have a disguised n+1 situation here, but i think that the only way to solve it
    # would be to add a thread identifier to the comment model
  end

  def new
    @comment = parent_content.replies.new(author: current_user)
  end

  def create
    @comment = parent_content.replies.new(comment_params)
    @comment.author = current_user

    if @comment.save # TODO: filter if the user doesnt have rights to comment
      redirect_to parent_content
    else
      render parent_content, status: :unprocessable_entity
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
    params.expect(comment: [ :body ])
  end
end
