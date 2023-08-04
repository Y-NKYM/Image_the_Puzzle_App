class RenameUserIdColumnToTagId < ActiveRecord::Migration[6.1]
  def change
    rename_column :post_tags, :user_id, :tag_id
  end
end
