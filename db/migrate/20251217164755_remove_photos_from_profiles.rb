class RemovePhotosFromProfiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :profiles, :avatar_photo, :string
    remove_column :profiles, :background_photo, :string
  end
end
