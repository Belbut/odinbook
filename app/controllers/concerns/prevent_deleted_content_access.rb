require "active_support/concern"

module PreventDeletedContentAccess
  extend ActiveSupport::Concern

  included do
    before_action :prevent_deleted_content_access, only: %i[edit update destroy]
  end

  def prevent_deleted_content_access
    content = current_user_model.find(params[:id])

    return unless content.deleted?

    redirect_to content, status: :unprocessable_entity
  end

  private

  def current_user_model
    case controller_name
    when "comments"
      current_user.comments
    when "posts"
      current_user.posts
    end
  end
end
