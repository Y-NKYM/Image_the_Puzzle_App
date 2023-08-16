class RenameUserColumnToNames < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :user, :name
  end
end
