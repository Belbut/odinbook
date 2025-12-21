class ProfilesController < ApplicationController
  before_action :load_profile, only: %i[edit update]

  def show
    @user = User.find(profile_params)
    @profile = @user.profile
    @attachments = Attachment.joins(post: :author)
                             .where(users: { id: params[:user_id] })
                             .order(created_at: :desc)
                             .limit(9)
    @posts = Post.includes(:author, :attachments).where(author: @user).order(created_at: :desc).limit(25)
    # TODO: use stimulus to load post in batches
  end

  def edit; end

  def update
    if @profile.update(update_form_params)
      redirect_to user_profile_path(current_user)
    else
      flash.now[:alert] = @profile.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def change_avatar
    @avatar_attachments = Attachment.includes(post: :author).where(users: { id: current_user },
                                                                   post: { category: :avatar_selection })
  end

  def change_background
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
