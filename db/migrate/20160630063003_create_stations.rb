class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.references :post,   		null: false
      t.references :yield_file, 	null: false
      t.string :name, 				null: false

      t.timestamps
    end

    add_index :stations, :name
    add_index :stations, :yield_file_id
  end
end
