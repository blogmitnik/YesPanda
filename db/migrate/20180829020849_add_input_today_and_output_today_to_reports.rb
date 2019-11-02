class AddInputTodayAndOutputTodayToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :input_today, :integer
  	add_column :reports, :output_today, :integer
  	add_column :report_mains, :input_today, :integer
  	add_column :report_mains, :output_today, :integer
  	add_column :report_minis, :input_today, :integer
  	add_column :report_minis, :output_today, :integer

  	add_index :reports, :input_today
  	add_index :reports, :output_today
  	add_index :report_mains, :input_today
  	add_index :report_mains, :output_today
  	add_index :report_minis, :input_today
  	add_index :report_minis, :output_today
  end
end
