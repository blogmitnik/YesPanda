class AddTimeStampToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :current_year, :integer
  	add_column :posts, :current_month, :integer
  	add_column :posts, :current_mday, :integer
  	add_column :posts, :current_hour, :integer

    add_column :posts, :current_year_main, :integer
    add_column :posts, :current_month_main, :integer
    add_column :posts, :current_mday_main, :integer
    add_column :posts, :current_hour_main, :integer

    add_column :posts, :current_year_mini, :integer
    add_column :posts, :current_month_mini, :integer
    add_column :posts, :current_mday_mini, :integer
    add_column :posts, :current_hour_mini, :integer

    add_index :posts, :current_year
    add_index :posts, :current_month
    add_index :posts, :current_mday
    add_index :posts, :current_hour

    add_index :posts, :current_year_main
    add_index :posts, :current_month_main
    add_index :posts, :current_mday_main
    add_index :posts, :current_hour_main

    add_index :posts, :current_year_mini
    add_index :posts, :current_month_mini
    add_index :posts, :current_mday_mini
    add_index :posts, :current_hour_mini
  end
end
