class AddCategoryToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :category, :string, null: false, default: :feed
    add_index :images, :category
  end
end
