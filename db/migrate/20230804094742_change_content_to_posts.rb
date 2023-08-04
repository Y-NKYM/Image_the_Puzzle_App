class ChangeContentToPosts < ActiveRecord::Migration[6.1]
  # null: falseが不要だったため
  def change
    remove_column :posts, :content, :text
    add_column :posts, :content, :text
  end
end
