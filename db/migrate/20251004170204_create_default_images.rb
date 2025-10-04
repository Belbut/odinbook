class CreateDefaultImages < ActiveRecord::Migration[8.0]
  def change
    create_table :default_images do |t|
      t.string :kind, null: false

      t.timestamps
    end
  end
end
