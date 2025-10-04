class AddIndexToDefaultImages < ActiveRecord::Migration[8.0]
  def change
    #         tablename         column
    add_index :default_images, :kind
  end
end
