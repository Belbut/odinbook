class ProfilesController < ApplicationController
  before_action :load_profile, only: %i[edit update]
  def show
    user = User.find(profile_params)
    @profile = user.profile
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
