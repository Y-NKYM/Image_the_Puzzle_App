class CreateOpinionBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :opinion_boxes do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :content, null: false
      t.boolean :is_read, null: false, default: false
      t.timestamps
    end
  end
end
