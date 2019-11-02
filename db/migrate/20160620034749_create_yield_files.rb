class CreateYieldFiles < ActiveRecord::Migration
  def change
    create_table :yield_files do |t|
      t.references :post,       null: false
      t.string :file_name, 	    null: false
      t.integer :total_row,     null: false
      t.datetime :published_at, null: false

      t.timestamps
    end

    add_index :yield_files, :file_name, :unique => true
    add_index :yield_files, :post_id
  end
end
