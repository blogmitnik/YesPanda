class AddProductIdToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :product_id, :integer
    add_index :posts, :product_id
  end
end
