require 'fileutils'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class ReportMain < ActiveRecord::Base
  attr_accessible :post_id, :yield_file_id, :station_id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, 
  :fail, :retest_process, :test_waive, :design_waive, :cof_waive, :rd_area, :bpl, :ntf, :failure_waive, :repaire_ok, 
  :inl_repaire, :dip, :defect, :fail_borrow, :pass_borrow, :yield_type, :published_at, :p_year, :p_month, :p_mday, :p_hour, :yield_rate, :yield_rate_today, :fp_yield_rate, :fp_yield_rate_today

  belongs_to :post
  belongs_to :yield_file
  belongs_to :station

  validates :post_id, :yield_file_id, :station_id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, :fail, :retest_process, :test_waive, 
    :design_waive, :cof_waive, :rd_area, :bpl, :ntf, :failure_waive, :repaire_ok, :inl_repaire, :dip, :defect, 
    :fail_borrow, :pass_borrow, :yield_type, :published_at, :p_year, :p_month, :p_mday, :p_hour, presence: true

  # Set yield report records per page
  paginates_per 20

  before_validation do
    if published_at
      self.p_year = published_at.year
      self.p_month = published_at.month
      self.p_mday = published_at.mday
      self.p_hour = published_at.hour
    end
  end

  # Caculate yield rate today
  # If timestamp of hour is 6am, Get year, month, day, post_id and station_name of the base record, 
  # and update each record's daily yield that belong to the same day with base record
  before_create do
    if self.p_hour.equal? 6
      records = ReportMain.where('post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND 
        ((p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_mday = ? AND p_hour BETWEEN ? AND ?))', 
        self.post_id, self.station_name, self.config, self.p_year, self.p_month, self.p_mday, 7, 23, self.p_mday + 1, 0, 5)
      if records.count > 0
        records.each do |record|
          output_today = (record.first_pass.to_i - self.first_pass.to_i) + (record.retest_pass.to_i - self.retest_pass.to_i) + (record.test_waive.to_i - self.test_waive.to_i) + (record.design_waive.to_i - self.design_waive.to_i) + 
          (record.cof_waive.to_i - self.cof_waive.to_i) + (record.ntf.to_i - self.ntf.to_i) + (record.failure_waive.to_i - self.failure_waive.to_i) + (record.repaire_ok.to_i - self.repaire_ok.to_i)
          input_today = record.input.to_i - self.input.to_i
          if !input_today.equal? 0
            yield_rate_today = (output_today.to_f / input_today.to_f) * 100
            yield_rate_today = yield_rate_today.round(2)
          else
            yield_rate_today = nil # Subtracted input is 0, show 'N/A' in page
          end
          record.update_attribute(:yield_rate_today, yield_rate_today)
        end
      end
    else
      # Get first record with same day
      datetime = DateTime.parse(self.published_at.to_s)
      if datetime.hour.between?(7, 23)
        # base_record = Report.where(post_id: post, station_name: self.station_name, config: self.config, p_year: datetime.year, p_month: datetime.month, p_mday: datetime.day, p_hour: 6).limit(1).first
        # If no base_record at 6am, get the record that 'p_hour' mostly close to 6 am as base_record 
        base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.station_name, self.config, datetime.year, datetime.month, datetime.day, 7).order("p_hour ASC").first
        # # If base_record hour have no station, create record data from current hour for the station at base_record hour
        # if base_record.nil?
        #   base_record_without_station = ReportMain.where("post_id = ? AND station_name = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.station_name, datetime.year, datetime.month, datetime.day, 6).order("p_hour ASC").first
        #   records = []
        #   columns = [:post_id, :yield_file_id, :station_id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, :fail, :retest_process, :test_waive, :design_waive, :cof_waive, :rd_area, :bpl, :ntf, :failure_waive, :repaire_ok, :inl_repaire, :dip, :defect, :fail_borrow, :pass_borrow, :yield_type, :yield_rate, :yield_rate_today, :fp_yield_rate, :fp_yield_rate_today, :published_at, :p_year, :p_month, :p_mday, :p_hour]
        #   begin
        #     # Create report items from CSV rows
        #     record = ReportMain.new(post_id: self.post_id, yield_file_id: base_record_without_station.yield_file_id, station_id: self.station_id, model: self.model.strip, stage: self.stage.strip, seqno: self.seqno, config: self.config, station_name: self.station_name, input: self.input, first_pass: self.first_pass, retest_pass: self.retest_pass, fail: self.fail, retest_process: self.retest_process, 
        #       test_waive: self.test_waive, design_waive: self.design_waive, cof_waive: self.cof_waive, rd_area: self.rd_area, bpl: self.bpl, ntf: self.ntf, 
        #       failure_waive: self.failure_waive, repaire_ok: self.repaire_ok, inl_repaire: self.inl_repaire, dip: self.dip, defect: self.defect, fail_borrow: self.fail_borrow, pass_borrow: self.pass_borrow, yield_type: self.yield_type, yield_rate: self.yield_rate, yield_rate_today: self.yield_rate_today, fp_yield_rate: self.fp_yield_rate, fp_yield_rate_today: self.fp_yield_rate_today, 
        #       published_at: base_record_without_station.published_at, p_year: datetime.year, p_month: datetime.month, p_mday: datetime.day, p_hour: base_record_without_station.p_hour
        #     )
        #     records << record
        #   rescue ActiveRecord::RecordInvalid => invalid
        #     puts invalid.record.errors
        #   end
        #   records.each do |record|
        #     record.run_callbacks(:create) { false }
        #   end
        #   ReportMain.import columns, records, validate: false
        # end
        # # Then check base_record again
        # base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.station_name, self.config, datetime.year, datetime.month, datetime.day, 6).order("p_hour ASC").first
      elsif datetime.hour.between?(0, 5)
        # base_record = Report.where(post_id: post, station_name: self.station_name, config: self.config, p_year: datetime.yesterday.year, p_month: datetime.yesterday.month, p_mday: datetime.yesterday.day, p_hour: 6).limit(1).first
        # If no base_record at 6am, get the record that 'p_hour' mostly close to 6 am as base_record 
        base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.station_name, self.config, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6).order("p_hour ASC").first
        # # If base_record hour have no station, create record data from current hour for the station at base_record hour
        # if base_record.nil?
        #   base_record_without_station = ReportMain.where("post_id = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.config, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6).order("p_hour ASC").first
        #   records = []
        #   columns = [:post_id, :yield_file_id, :station_id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, :fail, :retest_process, :test_waive, :design_waive, :cof_waive, :rd_area, :bpl, :ntf, :failure_waive, :repaire_ok, :inl_repaire, :dip, :defect, :fail_borrow, :pass_borrow, :yield_type, :yield_rate, :yield_rate_today, :fp_yield_rate, :fp_yield_rate_today, :published_at, :p_year, :p_month, :p_mday, :p_hour]
        #   begin
        #     # Create report items from CSV rows
        #     record = ReportMain.new(post_id: self.post_id, yield_file_id: base_record_without_station.yield_file_id, station_id: self.station_id, model: self.model.strip, stage: self.stage.strip, seqno: self.seqno, config: self.config, station_name: self.station_name, input: self.input, first_pass: self.first_pass, retest_pass: self.retest_pass, fail: self.fail, retest_process: self.retest_process, 
        #       test_waive: self.test_waive, design_waive: self.design_waive, cof_waive: self.cof_waive, rd_area: self.rd_area, bpl: self.bpl, ntf: self.ntf, 
        #       failure_waive: self.failure_waive, repaire_ok: self.repaire_ok, inl_repaire: self.inl_repaire, dip: self.dip, defect: self.defect, fail_borrow: self.fail_borrow, pass_borrow: self.pass_borrow, yield_type: self.yield_type, yield_rate: self.yield_rate, yield_rate_today: self.yield_rate_today, fp_yield_rate: self.fp_yield_rate, fp_yield_rate_today: self.fp_yield_rate_today, 
        #       published_at: base_record_without_station.published_at, p_year: datetime.yesterday.year, p_month: datetime.yesterday.month, p_mday: datetime.yesterday.day, p_hour: base_record_without_station.p_hour
        #     )
        #     records << record
        #   rescue ActiveRecord::RecordInvalid => invalid
        #     puts invalid.record.errors
        #   end
        #   records.each do |record|
        #     record.run_callbacks(:create) { false }
        #   end
        #   ReportMain.import columns, records, validate: false
        # end
        # # Then check base_record again
        # base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", self.post_id, self.station_name, self.config, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6).order("p_hour ASC").first
      end
      if base_record
        output_today = (self.first_pass.to_i - base_record.first_pass.to_i) + (self.retest_pass.to_i - base_record.retest_pass.to_i) + (self.test_waive.to_i - base_record.test_waive.to_i) + (self.design_waive.to_i - base_record.design_waive.to_i) + 
          (self.cof_waive.to_i - base_record.cof_waive.to_i) + (self.ntf.to_i - base_record.ntf.to_i) + (self.failure_waive.to_i - base_record.failure_waive.to_i) + (self.repaire_ok.to_i - base_record.repaire_ok.to_i)
        input_today = self.input.to_i - base_record.input.to_i
        if !input_today.equal? 0
          self.yield_rate_today = (output_today.to_f / input_today.to_f) * 100
          self.yield_rate_today = yield_rate_today.round(2)
          self.fp_yield_rate_today = ( (self.first_pass.to_f - base_record.first_pass.to_f) / input_today.to_f ) * 100
          self.fp_yield_rate_today = self.fp_yield_rate_today.round(2)
        else
          self.yield_rate_today = nil # Subtracted input is 0, show 'N/A' in page
          self.fp_yield_rate_today = nil # Subtracted input is 0, show 'N/A' in page
        end
      else
        # If base_record not found, set current record as base_record!
        self.yield_rate_today = nil
      end
    end
  end

  SORT_NAMES = %w(
    published_at model stage seqno station_name yield_rate
  )

  def self.sort_names
    SORT_NAMES
  end

  def base_record?
    datetime = DateTime.parse(self.published_at.to_s)
    if datetime.hour.between?(7, 23)
      return ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", self.post_id, self.station_name, self.config, datetime.year, datetime.month, datetime.day, 6, self.p_hour-1).first.equal? nil
    elsif datetime.hour.between?(0, 5)
      look_from_yesterday = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", self.post_id, self.station_name, self.config, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6, 23).first
      look_from_today = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", self.post_id, self.station_name, self.config, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 0, self.p_hour-1).first
      return look_from_yesterday.nil? && look_from_today.nil?
    else # datetime.hour is 6
      return true
    end
  end

  def self.group_accu_yield_by_date(date_time)
    reports = where("yield_rate IS NOT NULL AND published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, min(yield_rate) as worst_accu_yield")
    reports = reports.order("worst_accu_yield ASC")
  end

  def self.group_daily_yield_by_date(date_time)
    reports = where("yield_rate_today IS NOT NULL AND published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, min(yield_rate_today) as worst_daily_yield")
    reports = reports.order("worst_daily_yield ASC")
  end

  def self.group_fp_accu_yield_by_date(date_time)
    reports = where("fp_yield_rate IS NOT NULL AND published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, min(fp_yield_rate) as worst_fp_accu_yield")
    reports = reports.order("worst_fp_accu_yield ASC")
  end

  def self.group_fp_daily_yield_by_date(date_time)
    reports = where("fp_yield_rate_today IS NOT NULL AND published_at = ?", date_time)
    reports = reports.group("station_name")
    reports = reports.select("station_name, min(fp_yield_rate_today) as worst_fp_daily_yield")
    reports = reports.order("worst_fp_daily_yield ASC")
  end


  def self.group_station_accu_yield_by_date(date_time, station)
    reports = where("station_name = ? AND config != ? AND published_at = ? AND yield_rate IS NOT NULL", station, 'ALL', date_time)
    reports = reports.group("config").select("config, min(yield_rate) as worst_accu_yield").order("worst_accu_yield ASC")
  end

  def self.group_station_daily_yield_by_date(date_time, station)
    reports = where("station_name = ? AND config != ? AND published_at = ? AND yield_rate_today IS NOT NULL", station, 'ALL', date_time)
    reports = reports.group("config").select("config, min(yield_rate_today) as worst_daily_yield").order("worst_daily_yield ASC")
  end

  def self.group_station_fp_accu_yield_by_date(date_time, station)
    reports = where("station_name = ? AND config != ? AND published_at = ? AND fp_yield_rate IS NOT NULL", station, 'ALL', date_time)
    reports = reports.group("config").select("config, min(fp_yield_rate) as worst_fp_accu_yield").order("worst_fp_accu_yield ASC")
  end

  def self.group_station_fp_daily_yield_by_date(date_time, station)
    reports = where("station_name = ? AND config != ? AND published_at = ? AND fp_yield_rate_today IS NOT NULL", station, 'ALL', date_time)
    reports = reports.group("config").select("config, min(fp_yield_rate_today) as worst_fp_daily_yield").order("worst_fp_daily_yield ASC")
  end

  # The 'import' function can be used both on web and rake script
  def self.import_data(file, filename, post)
    # Check filename
    if csvfile = YieldFile.find_by_file_name(filename)
      yf_id = csvfile.id
    else
      line_count = CSV.open(file, "r").readlines.count - 1
      # Set published_at from file name, and create the file
      file_datetime = filename[filename.index('20'), 12]
      yield_file = YieldFile.create(post_id: post.id, file_name: filename, total_row: line_count, published_at: file_datetime)
      yf_id = yield_file.id
    end

    # Define the folder path of XML files, and then delete all files before importing new csv file
    base_dir = base_dir = "/Users/" + ENV['USER'] + "/desktop/TestXML/"
    file_model_stage_name = filename[filename.index('20')+12..filename.index('.csv')-1]
    file_stage_name = file_model_stage_name[file_model_stage_name.index('-')+1..-1]
    file_model_name = file_model_stage_name.split('-')[0]
    # if filename.include? "Sum-Config"
    #   # All XML files in JHxC folder
    #   files_to_clear = base_dir + file_stage_name.to_s + "/" + file_model_name.to_s + "C/*"
    # else
    #   # All XML files in JHx folder
    #   files_to_clear = base_dir + file_stage_name.to_s + "/" + file_model_name.to_s+ "/*"
    # end
    # FileUtils.rm_rf Dir.glob(files_to_clear)

    ReportMain.transaction do
      records = []
      columns = [:post_id, :yield_file_id, :station_id, :model, :stage, :seqno, :config, :station_name, :input, :first_pass, :retest_pass, :fail, :retest_process, :test_waive, :design_waive, :cof_waive, :rd_area, :bpl, :ntf, 
        :failure_waive, :repaire_ok, :inl_repaire, :dip, :defect, :fail_borrow, :pass_borrow, :yield_type, :yield_rate, :yield_rate_today, :fp_yield_rate, :fp_yield_rate_today, :published_at, :p_year, :p_month, :p_mday, :p_hour]

      CSV.foreach(file, {encoding: "UTF-8", quote_char: '"', col_sep: ',', row_sep: :auto, headers: true}) do |row|
        # Create station model and set station_id to Report obj
        if station = Station.find_by_name_and_post_id(row['Station'], post.id)
          sta_id = station.id
        else
          station = Station.create(post_id: post.id, yield_file_id: yf_id, name: row['Station'])
          sta_id = station.id
        end
        # Caculate accumulative yield rate
        if !row['Input'].to_i.equal? 0
          total = row['PFirstPass'].to_i + row['PRetestPass'].to_i + row['TestWF'].to_i + row['DesignWF'].to_i + row['COFWF'].to_i + row['NTF'].to_i + row['FailureWF'].to_i + row['RepairOK'].to_i
          yield_rate = ( (total.to_f / row['Input'].to_f) * 100 ).round(2)
          # Caculate FirstPass yield rate
          fp_yield_rate = ( (row['PFirstPass'].to_f / row['Input'].to_f) * 100 ).round(2)
          # Caculate FirstPass yield rate today
          fp_yield_rate_today = ( (row['PFirstPass'].to_f / row['Input'].to_f) * 100 ).round(2)
        else
          yield_rate = 99999 # Input is 0, show 'N/A' in page
          fp_yield_rate = 99999
          fp_yield_rate_today = 99999
        end


        if Time.parse(row['Date']).hour.to_i.equal? 6
          records_to_be_update = ReportMain.where('post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND 
            ((p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_mday = ? AND p_hour BETWEEN ? AND ?))', 
            post.id, row['Station'].to_s, row['Config'].to_s, Time.parse(row['Date']).year.to_i, Time.parse(row['Date']).month.to_i, Time.parse(row['Date']).day.to_i, 7, 23, Time.parse(row['Date']).day.to_i + 1, 0, 5)
          if records_to_be_update.count > 0
            Parallel.each(records_to_be_update, in_threads: 4) do |record|
              ActiveRecord::Base.connection_pool.with_connection do
                output_today = (record.first_pass.to_i - row['PFirstPass'].to_i) + (record.retest_pass.to_i - row['PRetestPass'].to_i) + (record.test_waive.to_i - row['TestWF'].to_i) + (record.design_waive.to_i - row['DesignWF'].to_i) + 
                (record.cof_waive.to_i - row['COFWF'].to_i) + (record.ntf.to_i - row['NTF'].to_i) + (record.failure_waive.to_i - row['FailureWF'].to_i) + (record.repaire_ok.to_i - row['RepairOK'].to_i)
                input_today = record.input.to_i - row['Input'].to_i
                yield_rate_today = input_today > 0 ? ( (output_today.to_f / input_today.to_f) * 100 ).round(2) : nil
                record.update_attribute(:yield_rate_today, yield_rate_today)
              end
            end
          end
          input_today = 0
          output_today = 0
          yield_rate_today = 99999
        else
          datetime = DateTime.parse(row['Date'].to_s)
          if datetime.hour.between?(7, 23)
            # If no base_record at 6am, get the record that 'p_hour' mostly close to 6 am as base_record 
            base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", post.id, row['Station'].to_s, row['Config'].to_s, datetime.year, datetime.month, datetime.day, 6).order("p_hour ASC").first
          elsif datetime.hour.between?(0, 5)
            # If no base_record at 6am, get the record that 'p_hour' mostly close to 6 am as base_record 
            base_record = ReportMain.where("post_id = ? AND station_name = ? AND config = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?", post.id, row['Station'].to_s, row['Config'].to_s, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6).order("p_hour ASC").first
          end

          if base_record
            output_today = (row['PFirstPass'].to_i - base_record.first_pass.to_i) + (row['PRetestPass'].to_i - base_record.retest_pass.to_i) + (row['TestWF'].to_i - base_record.test_waive.to_i) + (row['DesignWF'].to_i - base_record.design_waive.to_i) + 
              (row['COFWF'].to_i - base_record.cof_waive.to_i) + (row['NTF'].to_i - base_record.ntf.to_i) + (row['FailureWF'].to_i - base_record.failure_waive.to_i) + (row['RepairOK'].to_i - base_record.repaire_ok.to_i)
            input_today = row['Input'].to_i - base_record.input.to_i
            yield_rate_today = input_today > 0 ? ( (output_today.to_f / input_today.to_f) * 100 ).round(2) : 99999
            fp_yield_rate_today = input_today > 0 ? ( ( (row['PFirstPass'].to_f - base_record.first_pass.to_f) / input_today.to_f ) * 100 ).round(2) : 99999
          else
            input_today = 0
            output_today = 0
            yield_rate_today = 99999
          end
        end


        time_now = Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s
        #record = "(#{post.id}, #{yf_id}, #{sta_id}, '#{row['Model'].strip}', '#{row['Stage'].strip}', #{row['Seqno']}, '#{row['Config']}', '#{row['Station']}', #{row['Input']}, #{row['PFirstPass']}, #{row['PRetestPass']}, #{row['Fail']}, #{row['RetestProcess']}, #{row['TestWF']}, #{row['DesignWF']}, #{row['COFWF']}, #{row['RDArea']}, #{row['BPL']}, #{row['NTF']}, #{row['FailureWF']}, #{row['RepairOK']}, #{row['INLRepair']}, #{row['DIP']}, #{row['Defect']}, #{row['Fail_Borrow']}, #{row['Pass_Borrow']}, '#{row['Type']}', #{yield_rate}, NULL, #{fp_yield_rate}, #{fp_yield_rate_today}, '#{row['Date']}', #{Time.parse(row['Date']).year}, #{Time.parse(row['Date']).month}, #{Time.parse(row['Date']).day}, #{Time.parse(row['Date']).hour}, '#{time_now}', '#{time_now}')"
        #records += records.length == 0 ? "#{record}" : ", #{record}"
        record = [post.id, yf_id, sta_id, row['Model'].strip.to_s, row['Stage'].strip.to_s, row['Seqno'], row['Config'].to_s, row['Station'].to_s, 
          row['Input'], row['PFirstPass'], row['PRetestPass'], row['Fail'], row['RetestProcess'], 
          row['TestWF'], row['DesignWF'], row['COFWF'], 
          row['RDArea'], row['BPL'], row['NTF'], row['FailureWF'], row['RepairOK'], row['INLRepair'], 
          row['DIP'], row['Defect'], row['Fail_Borrow'], row['Pass_Borrow'], row['Type'].to_s, yield_rate, yield_rate_today, 
          fp_yield_rate, fp_yield_rate_today, row['Date'].to_s, 
          Time.parse(row['Date']).year, Time.parse(row['Date']).month, Time.parse(row['Date']).day, Time.parse(row['Date']).hour, 
          time_now, time_now, input_today, output_today]
        records << record
      end

      #values = records.map{ |record| "(#{record.join(",")})" }.join(",")
      #values = records.map{|record| "(#{record.map! {|c| record.find_index(c)==3 || record.find_index(c)==4 ? c='\'c\'' : c}.join(',')})"}.join(',').gsub('99999', 'NULL')
      values = records.map{ |record| "(#{record[0]}, #{record[1]}, #{record[2]}, '#{record[3]}', '#{record[4]}', #{record[5]}, '#{record[6]}', '#{record[7]}', #{record[8]}, #{record[9]}, #{record[10]}, #{record[11]}, #{record[12]}, #{record[13]}, #{record[14]}, #{record[15]}, #{record[16]}, #{record[17]}, #{record[18]}, #{record[19]}, #{record[20]}, #{record[21]}, #{record[22]}, #{record[23]}, #{record[24]}, #{record[25]}, '#{record[26]}', #{record[27]}, #{record[28]}, #{record[29]}, #{record[30]}, '#{record[31]}', #{record[32]}, #{record[33]}, #{record[34]}, #{record[35]}, '#{record[36]}', '#{record[37]}', '#{record[38]}', '#{record[39]}')" }.join(",").gsub('99999', 'NULL')
      sql = "INSERT INTO `#{self.table_name}` (`post_id`,`yield_file_id`,`station_id`,`model`,`stage`,`seqno`,`config`,`station_name`,`input`,`first_pass`,`retest_pass`,`fail`,`retest_process`,`test_waive`,`design_waive`,`cof_waive`,`rd_area`,`bpl`,`ntf`,`failure_waive`,`repaire_ok`,`inl_repaire`,`dip`,`defect`,`fail_borrow`,`pass_borrow`,`yield_type`,`yield_rate`,`yield_rate_today`,`fp_yield_rate`,`fp_yield_rate_today`,`published_at`,`p_year`,`p_month`,`p_mday`,`p_hour`,`created_at`,`updated_at`,`input_today`,`output_today`) VALUES #{values}"
      #ActiveRecord::Base.connection.execute(sql)
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        conn.execute(sql)
      end
    end

    # Then, update timestamp fields of post record to save the current timestamp of csv file
    the_year = filename[filename.index('20'), 4]
    the_month = filename[filename.index('20')+4, 2]
    the_day = filename[filename.index('20')+6, 2]
    the_hour = filename[filename.index('20')+8, 2]
    post.update_attributes(current_year_main: the_year, current_month_main: the_month, current_mday_main: the_day, current_hour_main: the_hour)

    # # Delete last hour's records from database (For always only keep 2 groups of hourly records)
    # the_post = Post.find_by_id(post.id)
    # the_year = filename[filename.index('20'), 4]
    # the_month = filename[filename.index('20')+4, 2]
    # the_day = filename[filename.index('20')+6, 2]
    # the_hour = filename[filename.index('20')+8, 2]
    # if !the_post.current_hour_main.nil?
    #   if !the_post.current_hour_main.to_s.eql? the_hour.to_i.to_s
    #     if !(the_hour.to_i >= 6 && the_post.current_hour_main.to_i < 6)
    #       check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", file_model_stage_name, the_post.current_year_main, the_post.current_month_main, the_post.current_mday_main, 6, the_hour.to_i-1)
    #       grup_hour = check_base_record.group("p_hour").count
    #       if grup_hour.count > 1
    #         puts "Deleting old timestamp MAIN records..."
    #         ReportMain.where(stage: file_model_stage_name, p_year: the_post.current_year_main, p_month: the_post.current_month_main, p_mday: the_post.current_mday_main, p_hour: the_post.current_hour_main).destroy_all
    #       end
    #     end
    #   end
    # end
    # # Then, update timestamp fields of post record to save the current timestamp of csv file
    # Post.find_by_id(post.id).update_attributes(current_year_main: the_year, current_month_main: the_month, current_mday_main: the_day, current_hour_main: the_hour)
  end

  def self.delete_overdue_records_beta(file_model_stage_name)
    # Delete overdue data records from database (Always keep only 2 groups of hourly timestamp records)
    the_post = Post.find_by_title(file_model_stage_name)
    the_year = the_post.current_year_main
    the_month = the_post.current_month_main
    the_day = the_post.current_mday_main
    the_hour = the_post.current_hour_main
    
    if !the_hour.nil?
      datetime = DateTime.parse(the_year.to_s + sprintf('%02d', the_month).to_s + the_day.to_s)
      if the_hour.to_i == 0
        check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
          file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23)
      elsif the_hour.to_i.between?(1, 5)
        check_base_record = ReportMain.where("stage = ? AND ( (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) )", 
          file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23,
          the_year, the_month, the_day, 0, the_hour.to_i-1)
      elsif the_hour.to_i.between?(6, 7)
        yesterday_latest_midnight_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
          file_model_stage_name, the_year, the_month, the_day, 0, 5).order("published_at DESC").first
        if yesterday_latest_midnight_record.nil?
          yesterday_latest_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
            file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23).order("published_at DESC").first
          if !yesterday_latest_record.nil?
            check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, yesterday_latest_record.p_hour.to_i-1)
          end
        else
          if yesterday_latest_midnight_record.p_hour == 0
            check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23)
          else
            check_base_record = ReportMain.where("stage = ? AND ( (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) )", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23,
              the_year, the_month, the_day, 0, yesterday_latest_midnight_record.p_hour.to_i-1)
          end
        end
      elsif the_hour.to_i.between?(8, 23)
        yesterday_latest_midnight_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
          file_model_stage_name, the_year, the_month, the_day, 0, 5).order("published_at DESC").first
        if yesterday_latest_midnight_record.nil?
          yesterday_latest_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
            file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23).order("published_at DESC").first
          if !yesterday_latest_record.nil?
            check_base_record = ReportMain.where("stage = ? AND ( (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) )", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, yesterday_latest_record.p_hour.to_i-1,
              the_year, the_month, the_day, 7, the_hour.to_i-1)
          else
            check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", 
              file_model_stage_name, the_year, the_month, the_day, 7, the_hour.to_i-1)
          end
        else
          if yesterday_latest_midnight_record.p_hour == 0
            check_base_record = ReportMain.where("stage = ? AND ( (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) )", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23,
              the_year, the_month, the_day, 7, the_hour.to_i-1)
          else
            check_base_record = ReportMain.where("stage = ? AND ( (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) OR (p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?) )", 
              file_model_stage_name, datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 7, 23,
              the_year, the_month, the_day, 0, yesterday_latest_midnight_record.p_hour.to_i-1)
          end
        end
      end
      if !check_base_record.nil?
        grup_hour = check_base_record.group("p_hour").count
        if grup_hour.count > 0
          puts "Deleting overdue Sum-Main records from database..."
          check_base_record.destroy_all
        end
      else
        puts "No overdue records to be delete!"
      end
    end
  end

  def self.delete_overdue_records(file_model_stage_name, latest_datetime)
    # Delete overdue data records from database (Always keep only 2 groups of hourly timestamp records)
    the_post = Post.find_by_title(file_model_stage_name)
    the_year = latest_datetime[0..3]
    the_month = latest_datetime[4..5]
    the_day = latest_datetime[6..7]
    the_hour = latest_datetime[8..9]
    if !the_post.current_hour.nil?
      if !the_post.current_hour.to_s.eql? the_hour.to_i.to_s
        if !(the_hour.to_i >= 6 && the_post.current_hour.to_i < 6)
          check_base_record = ReportMain.where("stage = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour BETWEEN ? AND ?", file_model_stage_name, the_post.current_year_main, the_post.current_month_main, the_post.current_mday_main, 6, the_hour.to_i-1)
          grup_hour = check_base_record.group("p_hour").count
          if grup_hour.count > 1
            puts "Deleting overdue Sum-All and Sum-Config records from database..."
            ReportMain.where(stage: file_model_stage_name, p_year: the_post.current_year_main, p_month: the_post.current_month_main, p_mday: the_post.current_mday_main, p_hour: the_post.current_hour_main).destroy_all
          end
        end
      end
    end
    # Then, update timestamp fields of post record to save the current timestamp of csv file
    the_post.update_attributes(current_year_main: the_year, current_month_main: the_month, current_mday_main: the_day, current_hour_main: the_hour)
  end

  def self.export_dummy_xml(target_stage, latest_datetime)
    base_dir = base_dir = "/Users/" + ENV['USER'] + "/desktop/TestXML/"
    puts "Start generating dummy (Main) XML files to " + base_dir

    stage_name = target_stage.to_s[target_stage.to_s.index('-')+1..-1]
    model_name = target_stage.to_s.split('-')[0]
    xml_root_dir = base_dir + stage_name.to_s
    station_xml_folder = xml_root_dir + "/" + model_name
    # Create folder for XML files if it does not exist
    FileUtils.mkdir_p xml_root_dir unless Dir.exist?(xml_root_dir)

    sum_all_root_xml_filename = xml_root_dir + "/" + model_name.to_s + "byConfig" + "/" + "Main.xml"
    sum_all_fp_root_xml_filename = xml_root_dir + "/" + model_name.to_s + "byConfig" + "/" + "Main_F.xml"
    today_yield_xml_filename = xml_root_dir + "/" + model_name.to_s + "byConfig" + "/" + "Main_T.xml"
    fp_today_yield_xml_filename = xml_root_dir + "/" + model_name.to_s + "byConfig" + "/" + "Main_FT.xml"

    tmp = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<Ntitle A=\"" + target_stage.to_s + "\"></Ntitle>\n<pubDate>" + latest_datetime.to_s + "</pubDate>\n</channel></rss>"
    
    # Write dummy xml content to the files 
    File.open(sum_all_root_xml_filename, 'w') do |f|
      f << tmp
    end
    File.open(sum_all_fp_root_xml_filename, 'w') do |f|
      f << tmp
    end
    File.open(today_yield_xml_filename, 'w') do |f|
      f << tmp
    end
    File.open(fp_today_yield_xml_filename, 'w') do |f|
      f << tmp
    end

    # Generate dummy XML folder
    station_xml_folder = xml_root_dir + "/" + model_name.to_s + "Main"
    FileUtils.mkdir_p station_xml_folder unless Dir.exist?(station_xml_folder)
  end

  def self.export_to_xml(target_stage)
    model_stage = Post.uniq.pluck(:title)
    base_dir = base_dir = "/Users/" + ENV['USER'] + "/desktop/TestXML/"
    server_url = "http://csmcfa01.quantacn.com:8087/PPP/TestXML/"
    puts "Start to exporting Main-build XML files to " + base_dir
    start_time = Time.now

    model_stage.each do |s|
      if s.eql? target_stage
        stage_name = s.to_s[s.to_s.index('-')+1..-1]
        model_name = s.to_s.split('-')[0]
        xml_root_dir = base_dir + stage_name.to_s
        station_xml_folder = xml_root_dir + "/" + model_name + "Main"
        # Create folder for XML files if it does not exist
        FileUtils.mkdir_p xml_root_dir unless Dir.exist?(xml_root_dir)

        # Generating station's XML files for Sum-All data
        sum_all_latest_record = ReportMain.where("stage = ?", s).order("published_at DESC").limit(1)[0]
        sum_all_records = ReportMain.where("stage = ? AND published_at = ?", 
          s, sum_all_latest_record.published_at).order("seqno ASC")
        sum_all_records_fp = ReportMain.where("stage = ? AND published_at = ? AND fp_yield_rate IS NOT NULL", 
          s, sum_all_latest_record.published_at).order("seqno ASC")
        today_yield_records = ReportMain.where("stage = ? AND published_at = ?", 
          s, sum_all_latest_record.published_at).order("seqno ASC")
        # Generate station's XML file for Sum-All records
        Parallel.each(sum_all_records, in_threads: 4) do |r|
          ActiveRecord::Base.connection_pool.with_connection do
            self.generate_station_xml(r)
          end
        end
        sum_all_root_xml_filename = xml_root_dir + "/" + sum_all_latest_record.model.to_s + "byConfig" + "/" + "Main.xml"
        sum_all_fp_root_xml_filename = xml_root_dir + "/" + sum_all_latest_record.model.to_s + "byConfig" + "/" + "Main_F.xml"
        today_yield_xml_filename = xml_root_dir + "/" + sum_all_latest_record.model.to_s + "byConfig" + "/" + "Main_T.xml"
        fp_today_yield_xml_filename = xml_root_dir + "/" + sum_all_latest_record.model.to_s + "byConfig" + "/" + "Main_FT.xml"
        # Generate root XML file in specific stage folder
        self.generate_root_xml(sum_all_records, sum_all_root_xml_filename)
        self.generate_fp_root_xml(sum_all_records, sum_all_records_fp, sum_all_fp_root_xml_filename)
        self.generate_today_yield_root_xml(today_yield_records, today_yield_xml_filename, fp_today_yield_xml_filename)
        #self.generate_fp_today_yield_root_xml(today_yield_records, fp_today_yield_xml_filename)
      end
    end
    end_time = Time.now
    puts "Completed exporting (Main) XML files in #{(end_time - start_time)} seconds"
  end

  def self.generate_station_xml(record)
    xml_header = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<title>" + record.station_name.to_s.gsub('/', '_').gsub('&', '_') + " Detail" + "</title>\n<pubDate>" + record.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link></link>\n"
    xml_model = "<item><title>Model</title>\n<pubDate>" + record.model.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_stage = "<item><title>Stage</title>\n<pubDate>" + record.stage.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_config = "<item><title>Config</title>\n<pubDate>" + record.config.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_station = "<item><title>Station</title>\n<pubDate>" + record.station_name.to_s.gsub('/', '_').gsub('&', '_') + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_input = "<item><title>Input</title>\n<pubDate>" + record.input.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_first_pass = "<item><title>FirstPass</title>\n<pubDate>" + record.first_pass.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_retest_pass = "<item><title>RetestPass</title>\n<pubDate>" + record.retest_pass.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_fail = "<item><title>FailOnlineFail</title>\n<pubDate>" + record.fail.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_retest_process = "<item><title>RetestProcess</title>\n<pubDate>" + record.retest_process.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_test_waive = "<item><title>TestWF</title>\n<pubDate>" + record.test_waive.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_design_waive = "<item><title>DesignWF</title>\n<pubDate>" + record.design_waive.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_cof_waive = "<item><title>COFWF</title>\n<pubDate>" + record.cof_waive.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_rd_area = "<item><title>RDArea</title>\n<pubDate>" + record.rd_area.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_bpl = "<item><title>BoundtoPL</title>\n<pubDate>" + record.bpl.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_ntf = "<item><title>NTF</title>\n<pubDate>" + record.ntf.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_failure_waive = "<item><title>FailureWF</title>\n<pubDate>" + record.failure_waive.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_repaire_ok = "<item><title>RepairOK</title>\n<pubDate>" + record.repaire_ok.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_inl_repaire = "<item><title>INLRepair</title>\n<pubDate>" + record.inl_repaire.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_dip = "<item><title>DIPScrap</title>\n<pubDate>" + record.dip.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_defect = "<item><title>Defect</title>\n<pubDate>" + record.defect.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_fail_borrow = "<item><title>Fail_Borrow</title>\n<pubDate>" + record.fail_borrow.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_pass_borrow = "<item><title>Pass_Borrow</title>\n<pubDate>" + record.pass_borrow.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_yield_type = "<item><title>Type</title>\n<pubDate>" + record.yield_type.to_s + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_ctime = "<item><title>CTime</title>\n<pubDate>" + record.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link>1</link><yield>1</yield></item>\n"
    xml_footer = "</channel></rss>"

    base_dir = base_dir = "/Users/" + ENV['USER'] + "/desktop/TestXML/"
    stage_name = record.stage.to_s[record.stage.to_s.index('-')+1..-1]
    xml_target_dir = base_dir + stage_name + "/" + record.model.to_s + "Main"

    # Create xml folder if it does not exist
    FileUtils.mkdir_p xml_target_dir unless Dir.exist?(xml_target_dir)
    # Define the xml file path (And removes all non-alphanumber characters from station_name)
    local_filename = xml_target_dir + "/" + record.station_name.to_s.gsub(/[^0-9a-z]/i, '') + ".xml"

    File.open(local_filename, 'w') { |f| f.write(xml_header + xml_model + xml_stage + xml_config + xml_station + xml_input + xml_first_pass + 
      xml_retest_pass + xml_fail + xml_retest_process + xml_test_waive + xml_design_waive + xml_cof_waive + xml_rd_area + xml_bpl + xml_ntf + xml_failure_waive + 
      xml_repaire_ok + xml_inl_repaire + xml_dip + xml_defect + xml_fail_borrow + xml_pass_borrow + xml_yield_type + xml_ctime + xml_footer) }
  end

  def self.generate_root_xml(records, root_xml_filename)
    server_url = "http://csmcfa01.quantacn.com:8087/PPP/TestXML/"
    tmp = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<Ntitle A=\"" + records.first.stage.to_s + "\"></Ntitle>\n<pubDate>" + records.first.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link></link>\n"
    Parallel.each(records, in_threads: 4) do |r|
      ActiveRecord::Base.connection_pool.with_connection do
        # Counting Output & WIP of each station
        output = r.first_pass.to_i + r.retest_pass.to_i + r.test_waive.to_i + r.design_waive.to_i + r.cof_waive.to_i + r.ntf.to_i + r.failure_waive.to_i + r.repaire_ok.to_i + r.inl_repaire.to_i
        if r.seqno.to_s.eql? "1"
          wip = 0
        else
          last_station = ReportMain.find_by_seqno_and_stage_and_config_and_published_at(r.seqno - 1, r.stage, r.config, r.published_at)
          if last_station.nil?
            wip = 0
          else
            last_station_output = last_station.first_pass.to_i + last_station.retest_pass.to_i + last_station.test_waive.to_i + last_station.design_waive.to_i + last_station.cof_waive.to_i + last_station.ntf.to_i + last_station.failure_waive.to_i + last_station.repaire_ok.to_i + last_station.inl_repaire.to_i
            wip = last_station_output - last_station.pass_borrow.to_i - r.input.to_i
            wip = 0 if wip < 0
          end
        end
        # If yield_rate is NULL in database, convert it to 'No Input'
        y_rate = r.yield_rate.nil? ? 'No Input' : r.yield_rate.to_s + '%'
        # For separating the XML file contents from 'Sum-All' and 'Sum-Config' file type
        station_name = r.station_name.to_s.gsub('/', '_').gsub('&', '_')
        xml_filename = r.station_name.to_s.gsub(/[^0-9a-z]/i, '')
        model_name = r.model.to_s

        # Get stage name without model (ex. EVT)
        stage_name = r.stage.to_s[r.stage.to_s.index('-')+1..-1]
        # Write data from csv row data to XML file
        tmp << "<item><title>" + station_name + "</title>\n<pubDate>Input:" + r.input.to_s + " Output:" + output.to_s + " WIP:" + wip.to_s + " FAIL:" + r.fail.to_s + "</pubDate>\n<yield>" + y_rate + "</yield>\n<sflow>" + r.seqno.to_s + "</sflow>\n<link>" + server_url + stage_name + "/" + model_name + "Main/" + xml_filename + ".xml</link></item>\n"
      end
    end
    tmp << "</channel></rss>"
    # Write xml content to the file 
    File.open(root_xml_filename, 'w') do |f|
      f << tmp
    end
  end

  def self.generate_fp_root_xml(records, records_fp, fp_root_xml_filename)
    server_url = "http://csmcfa01.quantacn.com:8087/PPP/TestXML/"
    # XML file path for showing FirstPass yield
    tmp = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<Ntitle A=\"" + records.first.stage.to_s + "\"></Ntitle>\n<pubDate>" + records.first.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link></link>\n"
    Parallel.each(records_fp, in_threads: 4) do |r|
      ActiveRecord::Base.connection_pool.with_connection do
        # Counting Output & WIP of each station
        output = r.first_pass.to_i + r.retest_pass.to_i + r.test_waive.to_i + r.design_waive.to_i + r.cof_waive.to_i + r.ntf.to_i + r.failure_waive.to_i + r.repaire_ok.to_i + r.inl_repaire.to_i
        if r.seqno.to_s.eql? "1"
          wip = 0
        else
          last_station = ReportMain.find_by_seqno_and_stage_and_config_and_published_at(r.seqno - 1, r.stage, r.config, r.published_at)
          if last_station.nil?
            wip = 0
          else
            last_station_output = last_station.first_pass.to_i + last_station.retest_pass.to_i + last_station.test_waive.to_i + last_station.design_waive.to_i + last_station.cof_waive.to_i + last_station.ntf.to_i + last_station.failure_waive.to_i + last_station.repaire_ok.to_i + last_station.inl_repaire.to_i
            wip = last_station_output - last_station.pass_borrow.to_i - r.input.to_i
            wip = 0 if wip < 0
          end
        end
        # Counting FirstPass yield rate, if fp_yield_rate is NULL in database, convert it to 'No Input'
        fp_yield_rate = r.fp_yield_rate.nil? ? 'No Input' : r.fp_yield_rate.to_s + '%'
        # For separating the XML file contents from 'Sum-All' and 'Sum-Config' file type
        station_name = r.station_name.to_s.gsub('/', '_').gsub('&', '_')
        xml_filename = r.station_name.to_s.gsub(/[^0-9a-z]/i, '')
        model_name = r.model.to_s

        # Get stage name without model (ex. EVT)
        stage_name = r.stage.to_s[r.stage.to_s.index('-')+1..-1]
        # Write data from csv row data to XML file
        tmp << "<item><title>" + station_name + "</title>\n<pubDate>Input:" + r.input.to_s + " Output:" + output.to_s + " WIP:" + wip.to_s + " FAIL:" + r.fail.to_s + "</pubDate>\n<yield>" + fp_yield_rate + "</yield>\n<sflow>" + r.seqno.to_s + "</sflow>\n<link>" + server_url + stage_name + "/" + model_name + "Main/" + xml_filename + ".xml</link></item>\n"
      end
    end
    tmp << "</channel></rss>"
    # Write xml content to the file 
    File.open(fp_root_xml_filename, 'w') do |f|
      f << tmp
    end
  end

  def self.generate_today_yield_root_xml(records, today_yield_xml_filename, fp_today_yield_xml_filename)
    server_url = "http://csmcfa01.quantacn.com:8087/PPP/TestXML/"
    tmp = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<Ntitle A=\"" + records.first.stage.to_s + "\"></Ntitle>\n<pubDate>" + records.first.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link></link>\n"
    tmp2 = "<?xml version=\"1.0\" ?><rss version=\"2.0\"><channel>\n<Ntitle A=\"" + records.first.stage.to_s + "\"></Ntitle>\n<pubDate>" + records.first.published_at.to_s.gsub(' UTC', '') + "</pubDate>\n<link></link>\n"
    Parallel.each(records, in_threads: 4) do |r|
      ActiveRecord::Base.connection_pool.with_connection do
        # Counting Output & WIP of each station
        output = r.first_pass.to_i + r.retest_pass.to_i + r.test_waive.to_i + r.design_waive.to_i + r.cof_waive.to_i + r.ntf.to_i + r.failure_waive.to_i + r.repaire_ok.to_i + r.inl_repaire.to_i
        if r.seqno.to_s.eql? "1"
          wip = 0
        else
          last_station = ReportMain.find_by_seqno_and_stage_and_config_and_published_at(r.seqno - 1, r.stage, r.config, r.published_at)
          if last_station.nil?
            wip = 0
          else
            last_station_output = last_station.first_pass.to_i + last_station.retest_pass.to_i + last_station.test_waive.to_i + last_station.design_waive.to_i + last_station.cof_waive.to_i + last_station.ntf.to_i + last_station.failure_waive.to_i + last_station.repaire_ok.to_i + last_station.inl_repaire.to_i
            wip = last_station_output - last_station.pass_borrow.to_i - r.input.to_i
            wip = 0 if wip < 0
          end
        end
        # If yield_rate is NULL in database, convert it to 'No Input'
        y_rate = r.yield_rate_today.nil? ? 'No Input' : r.yield_rate_today.to_s + '%'
        y_rate_fp = r.fp_yield_rate_today.nil? ? 'No Input' : r.fp_yield_rate_today.to_s + '%'
        # For separating the XML file contents from 'Sum-All' and 'Sum-Config' file type
        station_name = r.station_name.to_s.gsub('/', '_').gsub('&', '_')
        xml_filename = r.station_name.to_s.gsub(/[^0-9a-z]/i, '')
        model_name = r.model.to_s

        # Get stage name without model (ex. EVT)
        stage_name = r.stage.to_s[r.stage.to_s.index('-')+1..-1]
        # Write data from csv row data to XML file
        tmp << "<item><title>" + station_name + "</title>\n<pubDate>Input:" + r.input.to_s + " Output:" + output.to_s + " WIP:" + wip.to_s + " FAIL:" + r.fail.to_s + "</pubDate>\n<yield>" + y_rate + "</yield>\n<sflow>" + r.seqno.to_s + "</sflow>\n<link>" + server_url + stage_name + "/" + model_name + "Main/" + xml_filename + ".xml</link></item>\n"
        tmp2 << "<item><title>" + station_name + "</title>\n<pubDate>Input:" + r.input.to_s + " Output:" + output.to_s + " WIP:" + wip.to_s + " FAIL:" + r.fail.to_s + "</pubDate>\n<yield>" + y_rate_fp + "</yield>\n<sflow>" + r.seqno.to_s + "</sflow>\n<link>" + server_url + stage_name + "/" + model_name + "Main/" + xml_filename + ".xml</link></item>\n"
      end
    end
    tmp << "</channel></rss>"
    tmp2 << "</channel></rss>"
    # Write xml content to the file 
    File.open(today_yield_xml_filename, 'w') do |f|
      f << tmp
    end
    File.open(fp_today_yield_xml_filename, 'w') do |f|
      f << tmp2
    end
  end
end
