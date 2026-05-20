class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
                 .where.not(id: current_user.id)
  end
end
