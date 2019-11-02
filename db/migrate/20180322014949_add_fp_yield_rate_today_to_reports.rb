class AddFpYieldRateTodayToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :fp_yield_rate_today, :float
  	add_column :report_mains, :fp_yield_rate_today, :float
  	add_column :report_minis, :fp_yield_rate_today, :float

	add_index :reports, :fp_yield_rate_today
	add_index :report_mains, :fp_yield_rate_today
  	add_index :report_minis, :fp_yield_rate_today
  end
end
