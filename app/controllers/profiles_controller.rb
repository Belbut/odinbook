class ProfilesController < ApplicationController
  before_action :load_profile, only: %i[edit update]

  def show
    @user = User.find(profile_params)
    @profile = @user.profile
    @attachments = Attachment.joins(post: :author)
                             .where(users: { id: params[:user_id] })
                             .order(created_at: :desc)
                             .limit(9)
    @posts = Post.active.includes(:author, :attachments).where(author: @user).order(created_at: :desc).limit(25)
    @post = Post.new
    # TODO: use stimulus to load post in batches
  end

  def edit
    @user = current_user
    @profile = @user.profile
  end

  def update
    if @profile.update(update_form_params)
      redirect_to user_profile_path(current_user)
    else
      flash.now[:alert] = @profile.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    sanitized_input = Profile.sanitize_sql_like(params[:search][:query])
    @profiles = Profile.name_search(sanitized_input)
  end

  def change_avatar
    @post = Post.new(category: :avatar_selection)
    @avatar_attachments = Attachment.includes(post: :author).where(users: { id: current_user },
                                                                   post: { category: :avatar_selection })
  end

  def change_background
    @post = Post.new(category: :background_selection)
    @background_attachments = Attachment.includes(post: :author).where(users: { id: current_user },
                                                                       post: { category: :background_selection })
  end

  private

  def profile_params
    params.expect(:user_id)
  end

  def update_form_params
    params.expect(profile: %i[name birthday location])
  end

  def load_profile
    @profile = current_user.profile
  end
end
