class ProfilesController < ApplicationController
  before_action :load_profile, only: %i[edit update]
  def show
    user = User.find(profile_params)
    @profile = user.profile
  end

  def edit
    nil
  end

  def update; end

  private

  def profile_params
    params.expect(:user_id)
  end

  def load_profile
    @profile = current_user.profile
  end
end
