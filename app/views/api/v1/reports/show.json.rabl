object @report

attributes :id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, :fail, :retest_process, :test_waive, :design_waive, :cof_waive, :rd_area, :bpl, :ntf, :failure_waive, :repaire_ok, :inl_repaire, :dip, :defect, :fail_borrow, :pass_borrow, :yield_type, :yield_rate, :published_at, :p_year, :p_month, :p_mday, :p_hour

node(:created_at) { |p| p.created_at.iso8601 }
node(:updated_at) { |p| p.updated_at.iso8601 }
node(:published_at) { |p| p.published_at.iso8601 }