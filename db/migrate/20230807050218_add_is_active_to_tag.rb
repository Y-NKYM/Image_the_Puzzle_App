class AddIsActiveToTag < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :is_active, :boolean, null: false, default: true
  end
end
