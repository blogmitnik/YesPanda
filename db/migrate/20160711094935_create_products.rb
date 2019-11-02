class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
    add_index :products, :user_id
    add_index :products, :title
  end
end
