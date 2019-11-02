class CreateReportMinis < ActiveRecord::Migration
  def change
    create_table :report_minis do |t|
      t.references :post,         null: false
      t.references :yield_file,   null: false
      t.references :station,      null: false
      t.string :model,            null: false
      t.string :stage,            null: false
      t.integer :seqno,           null: false
      t.string :config,           null: false
      t.string :station_name,     null: false
      t.integer :input,           null: false
      t.integer :first_pass,      null: false
      t.integer :retest_pass,     null: false
      t.integer :fail,            null: false
      t.integer :retest_process,  null: false
      t.integer :test_waive,      null: false
      t.integer :design_waive,    null: false
      t.integer :cof_waive,       null: false
      t.integer :rd_area,         null: false
      t.integer :bpl,             null: false
      t.integer :ntf,             null: false
      t.integer :failure_waive,   null: false
      t.integer :repaire_ok,      null: false
      t.integer :inl_repaire,     null: false
      t.integer :dip,             null: false
      t.integer :defect,          null: false
      t.integer :fail_borrow,     null: false
      t.integer :pass_borrow,     null: false
      t.string :yield_type,       null: false
      t.float :yield_rate
      t.float :yield_rate_today
      t.float :fp_yield_rate
      t.datetime :published_at,   null: false
      t.integer :p_year,          null: false
      t.integer :p_month,         null: false
      t.integer :p_mday,          null: false
      t.integer :p_hour,          null: false

      t.timestamps
    end

    add_index :report_minis, :post_id
    add_index :report_minis, :yield_file_id
    add_index :report_minis, :station_id
    add_index :report_minis, [:station_id, :published_at ]
    add_index :report_minis, [:station_id, :p_hour ]
    add_index :report_minis, :model
    add_index :report_minis, :stage
    add_index :report_minis, :seqno
    add_index :report_minis, :station_name
    add_index :report_minis, :yield_rate
    add_index :report_minis, :yield_rate_today
    add_index :report_minis, :fp_yield_rate
    add_index :report_minis, :published_at
    add_index :report_minis, [ :p_year, :p_month, :p_mday ]
    add_index :report_minis, [ :p_year, :p_month, :p_mday, :p_hour ]
  end
end
