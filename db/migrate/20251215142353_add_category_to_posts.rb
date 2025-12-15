class AddCategoryToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :category, :string, null: false, default: "feed"
    add_index :posts, :category
  end
end
