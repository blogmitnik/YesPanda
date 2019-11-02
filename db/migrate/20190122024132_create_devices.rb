class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string :uuid
      t.string :platform
      t.boolean :enabled, default: true

      t.timestamps
    end

    add_index :devices, :user_id
    add_index :devices, :uuid
  end
end
