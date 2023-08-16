class RenameNameColumnToPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :name, :title
  end
end
