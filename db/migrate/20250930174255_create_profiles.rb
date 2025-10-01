class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.date :birthday
      t.string :profile_photo
      t.string :background_photo
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
