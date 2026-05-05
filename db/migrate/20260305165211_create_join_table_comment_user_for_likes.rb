class CreateJoinTableCommentUserForLikes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :comments, :users do |t|
      # t.index [:comment_id, :user_id]
      # t.index [:user_id, :comment_id]
    end
    add_index(:comments_users, %i[comment_id user_id], unique: true)
  end
end
