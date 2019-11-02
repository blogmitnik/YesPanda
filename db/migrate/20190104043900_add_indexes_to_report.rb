class AddIndexesToReport < ActiveRecord::Migration
  def change
  	add_index :reports, [:stage, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_1'
  	add_index :reports, [:stage, :config, :published_at], name: 'super_index_2'
  	add_index :reports, [:seqno, :stage, :config, :published_at], name: 'super_index_3'
  	add_index :reports, [:post_id, :station_name, :config, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_4'
  	add_index :reports, [:config, :yield_rate, :published_at], name: 'super_index_5'
  	add_index :reports, [:config, :yield_rate_today, :published_at], name: 'super_index_6'
  	add_index :reports, [:config, :fp_yield_rate, :published_at], name: 'super_index_7'
  	add_index :reports, [:config, :fp_yield_rate_today, :published_at], name: 'super_index_8'

  	add_index :report_mains, [:stage, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_9'
  	add_index :report_mains, [:stage, :config, :published_at], name: 'super_index_10'
  	add_index :report_mains, [:seqno, :stage, :config, :published_at], name: 'super_index_11'
  	add_index :report_mains, [:post_id, :station_name, :config, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_12'
  	add_index :report_mains, [:config, :yield_rate, :published_at], name: 'super_index_13'
  	add_index :report_mains, [:config, :yield_rate_today, :published_at], name: 'super_index_14'
  	add_index :report_mains, [:config, :fp_yield_rate, :published_at], name: 'super_index_15'
  	add_index :report_mains, [:config, :fp_yield_rate_today, :published_at], name: 'super_index_16'

  	add_index :report_minis, [:stage, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_17'
  	add_index :report_minis, [:stage, :config, :published_at], name: 'super_index_18'
  	add_index :report_minis, [:seqno, :stage, :config, :published_at], name: 'super_index_19'
  	add_index :report_minis, [:post_id, :station_name, :config, :p_year, :p_month, :p_mday, :p_hour], name: 'super_index_20'
  	add_index :report_minis, [:config, :yield_rate, :published_at], name: 'super_index_21'
  	add_index :report_minis, [:config, :yield_rate_today, :published_at], name: 'super_index_22'
  	add_index :report_minis, [:config, :fp_yield_rate, :published_at], name: 'super_index_23'
  	add_index :report_minis, [:config, :fp_yield_rate_today, :published_at], name: 'super_index_24'
  end
end
