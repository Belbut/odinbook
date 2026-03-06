class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :contentable_type
      t.integer :contentable_id

      t.references :user, null: false, foreign_key: true
      t.string :body
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
