class CreateApnClients < ActiveRecord::Migration
  def change
    create_table :apn_clients do |t|

      t.timestamps
    end
  end
end
