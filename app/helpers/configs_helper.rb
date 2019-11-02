module ConfigsHelper
  def worst_config_yield_chart_data(reports)
    start_time = reports.last.published_at
    end_time = reports.first.published_at
    post_id = reports.first.post_id
    station = reports.first.station_name
    if controller.controller_name == "reports"
      # For search build page
      datetime = reports.select("distinct(published_at)")
    else
      # For general build page
      datetime = Report.where("post_id = ? AND config = ? AND published_at BETWEEN ? AND ?", post_id, 'ALL', start_time, end_time).select("distinct(published_at)")
    end
    datetime.map do |date|
    {
      published_at: date.published_at.to_datetime.to_formatted_s(:long),
      # No.1 worst yield rate & station name
      worst_accu_yield: Report.group_station_accu_yield_by_date(date.published_at, station).first.try(:worst_accu_yield),
      worst_daily_yield: Report.group_station_daily_yield_by_date(date.published_at, station).first.try(:worst_daily_yield),
      worst_fp_accu_yield: Report.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:worst_fp_accu_yield),
      worst_fp_daily_yield: Report.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:worst_fp_daily_yield),
      worst_accu_config: Report.group_station_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_daily_config: Report.group_station_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_accu_config: Report.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_daily_config: Report.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      # No.2 Worst yield rate & station name
      worse_accu_yield: Report.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_accu_yield),
      worse_daily_yield: Report.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_daily_yield),
      worse_fp_accu_yield: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_accu_yield),
      worse_fp_daily_yield: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_daily_yield),
      worse_accu_config: Report.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_daily_config: Report.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_accu_config: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_daily_config: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      # No.3 worst yield rate & station name
      bad_accu_yield: Report.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_accu_yield),
      bad_daily_yield: Report.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_daily_yield),
      bad_fp_accu_yield: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_accu_yield),
      bad_fp_daily_yield: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_daily_yield),
      bad_accu_config: Report.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_daily_config: Report.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_accu_config: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_daily_config: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      # No.4 worst yield rate & station name
      bad2_accu_yield: Report.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_accu_yield),
      bad2_daily_yield: Report.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_daily_yield),
      bad2_fp_accu_yield: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_accu_yield),
      bad2_fp_daily_yield: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_daily_yield),
      bad2_accu_config: Report.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_daily_config: Report.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_accu_config: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_daily_config: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      # No.5 worst yield rate & station name
      bad3_accu_yield: Report.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_accu_yield),
      bad3_daily_yield: Report.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_daily_yield),
      bad3_fp_accu_yield: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_accu_yield),
      bad3_fp_daily_yield: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_daily_yield),
      bad3_accu_config: Report.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_daily_config: Report.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_accu_config: Report.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_daily_config: Report.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input'
    }
    end
  end

  def worst_config_yield_chart_main_data(reports)
    start_time = reports.last.published_at
    end_time = reports.first.published_at
    post_id = reports.first.post_id
    station = reports.first.station_name
    if controller.controller_name == "reports"
      # For search build page
      datetime = reports.select("distinct(published_at)")
    else
      datetime = ReportMain.where("post_id = ? AND published_at BETWEEN ? AND ?", post_id, start_time, end_time).select("distinct(published_at)")
    end
    datetime.map do |date|
    {
      published_at: date.published_at.to_datetime.to_formatted_s(:long),
      # No.1 worst yield rate & station name
      worst_accu_yield: ReportMain.group_station_accu_yield_by_date(date.published_at, station).first.try(:worst_accu_yield),
      worst_daily_yield: ReportMain.group_station_daily_yield_by_date(date.published_at, station).first.try(:worst_daily_yield),
      worst_fp_accu_yield: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:worst_fp_accu_yield),
      worst_fp_daily_yield: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:worst_fp_daily_yield),
      worst_accu_config: ReportMain.group_station_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_daily_config: ReportMain.group_station_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_accu_config: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_daily_config: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      # No.2 Worst yield rate & station name
      worse_accu_yield: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_accu_yield),
      worse_daily_yield: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_daily_yield),
      worse_fp_accu_yield: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_accu_yield),
      worse_fp_daily_yield: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_daily_yield),
      worse_accu_config: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_daily_config: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_accu_config: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_daily_config: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      # No.3 worst yield rate & station name
      bad_accu_yield: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_accu_yield),
      bad_daily_yield: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_daily_yield),
      bad_fp_accu_yield: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_accu_yield),
      bad_fp_daily_yield: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_daily_yield),
      bad_accu_config: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_daily_config: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_accu_config: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_daily_config: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      # No.4 worst yield rate & station name
      bad2_accu_yield: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_accu_yield),
      bad2_daily_yield: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_daily_yield),
      bad2_fp_accu_yield: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_accu_yield),
      bad2_fp_daily_yield: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_daily_yield),
      bad2_accu_config: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_daily_config: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_accu_config: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_daily_config: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      # No.5 worst yield rate & station name
      bad3_accu_yield: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_accu_yield),
      bad3_daily_yield: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_daily_yield),
      bad3_fp_accu_yield: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_accu_yield),
      bad3_fp_daily_yield: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_daily_yield),
      bad3_accu_config: ReportMain.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_daily_config: ReportMain.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_accu_config: ReportMain.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_daily_config: ReportMain.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input'
    }
    end
  end

  def worst_config_yield_chart_mini_data(reports)
    start_time = reports.last.published_at
    end_time = reports.first.published_at
    post_id = reports.first.post_id
    station = reports.first.station_name
    if controller.controller_name == "reports"
      # For search build page
      datetime = reports.select("distinct(published_at)")
    else
      datetime = ReportMini.where("post_id = ? AND published_at BETWEEN ? AND ?", post_id, start_time, end_time).select("distinct(published_at)")
    end
    datetime.map do |date|
    {
      published_at: date.published_at.to_datetime.to_formatted_s(:long),
      # No.1 worst yield rate & station name
      worst_accu_yield: ReportMini.group_station_accu_yield_by_date(date.published_at, station).first.try(:worst_accu_yield),
      worst_daily_yield: ReportMini.group_station_daily_yield_by_date(date.published_at, station).first.try(:worst_daily_yield),
      worst_fp_accu_yield: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:worst_fp_accu_yield),
      worst_fp_daily_yield: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:worst_fp_daily_yield),
      worst_accu_config: ReportMini.group_station_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_daily_config: ReportMini.group_station_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_accu_config: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      worst_fp_daily_config: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).first.try(:config) || 'No Input',
      # No.2 Worst yield rate & station name
      worse_accu_yield: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_accu_yield),
      worse_daily_yield: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_daily_yield),
      worse_fp_accu_yield: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_accu_yield),
      worse_fp_daily_yield: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:worst_fp_daily_yield),
      worse_accu_config: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_daily_config: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_accu_config: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      worse_fp_daily_config: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(1).first.try(:config) || 'No Input',
      # No.3 worst yield rate & station name
      bad_accu_yield: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_accu_yield),
      bad_daily_yield: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_daily_yield),
      bad_fp_accu_yield: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_accu_yield),
      bad_fp_daily_yield: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:worst_fp_daily_yield),
      bad_accu_config: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_daily_config: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_accu_config: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      bad_fp_daily_config: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(2).first.try(:config) || 'No Input',
      # No.4 worst yield rate & station name
      bad2_accu_yield: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_accu_yield),
      bad2_daily_yield: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_daily_yield),
      bad2_fp_accu_yield: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_accu_yield),
      bad2_fp_daily_yield: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:worst_fp_daily_yield),
      bad2_accu_config: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_daily_config: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_accu_config: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      bad2_fp_daily_config: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(3).first.try(:config) || 'No Input',
      # No.5 worst yield rate & station name
      bad3_accu_yield: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_accu_yield),
      bad3_daily_yield: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_daily_yield),
      bad3_fp_accu_yield: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_accu_yield),
      bad3_fp_daily_yield: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:worst_fp_daily_yield),
      bad3_accu_config: ReportMini.group_station_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_daily_config: ReportMini.group_station_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_accu_config: ReportMini.group_station_fp_accu_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input',
      bad3_fp_daily_config: ReportMini.group_station_fp_daily_yield_by_date(date.published_at, station).offset(4).first.try(:config) || 'No Input'
    }
    end
  end

  def accu_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    datetime = reports.first.published_at

    # overflow_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate > ?", 'ALL', station, datetime, 100.00).count
    # great_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 99.51, 100.00).count
    # bad_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 90.00, 99.50).count
    # worse_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 0.00, 89.99).count
    # no_input_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate IS NULL", 'ALL', station, datetime).count
    
    overflow_accu_yield = reports.where("yield_rate > ?", 100.00).count
    great_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 99.51, 100.00).count
    bad_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 90.00, 99.50).count
    worse_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 0.00, 89.99).count
    no_input_yield = reports.where("yield_rate IS NULL").count

    overflow_accu_yield_rate = ((overflow_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    great_accu_yield_rate = ((great_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_accu_yield_rate = ((bad_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_accu_yield_rate = ((worse_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_accu_yield, great_accu_yield, bad_accu_yield, worse_accu_yield, no_input_yield]
    title = ['Overflow Accu Yield', 'Verified Accu Yield', 'Bad Accu Yield', 'Worse Accu Yield', 'No Input']
    percent = [overflow_accu_yield_rate, great_accu_yield_rate, bad_accu_yield_rate, worse_accu_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end

  def daily_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    datetime = reports.first.published_at

    # overflow_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today > ?", 'ALL', station, datetime, 100.00).count
    # great_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 99.51, 100.00).count
    # bad_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 90.00, 99.50).count
    # worse_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 0.00, 89.99).count
    # no_input_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today IS NULL", 'ALL', station, datetime).count
    
    overflow_daily_yield = reports.where("yield_rate_today > ?", 100.00).count
    great_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 99.51, 100.00).count
    bad_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 90.00, 99.50).count
    worse_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 0.00, 89.99).count
    no_input_yield = reports.where("yield_rate_today IS NULL").count

    overflow_daily_yield_rate = ((overflow_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    great_daily_yield_rate = ((great_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_daily_yield_rate = ((bad_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_daily_yield_rate = ((worse_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_daily_yield, great_daily_yield, bad_daily_yield, worse_daily_yield, no_input_yield]
    title = ['Overflow Daily Yield', 'Verified Daily Yield', 'Bad Daily Yield', 'Worse Daily Yield', 'No Input']
    percent = [overflow_daily_yield_rate, great_daily_yield_rate, bad_daily_yield_rate, worse_daily_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end

  def fp_accu_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    datetime = reports.first.published_at

    # overflow_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate > ?", 'ALL', station, datetime, 100.00).count
    # great_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 99.51, 100.00).count
    # bad_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 90.00, 99.50).count
    # worse_accu_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate >= ? AND yield_rate <= ?", 'ALL', station, datetime, 0.00, 89.99).count
    # no_input_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate IS NULL", 'ALL', station, datetime).count
    
    overflow_accu_yield = reports.where("fp_yield_rate > ?", 100.00).count
    great_accu_yield = reports.where("fp_yield_rate >= ? AND fp_yield_rate <= ?", 99.51, 100.00).count
    bad_accu_yield = reports.where("fp_yield_rate >= ? AND fp_yield_rate <= ?", 90.00, 99.50).count
    worse_accu_yield = reports.where("fp_yield_rate >= ? AND fp_yield_rate <= ?", 0.00, 89.99).count
    no_input_yield = reports.where("fp_yield_rate IS NULL").count

    overflow_accu_yield_rate = ((overflow_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    great_accu_yield_rate = ((great_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_accu_yield_rate = ((bad_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_accu_yield_rate = ((worse_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_accu_yield, great_accu_yield, bad_accu_yield, worse_accu_yield, no_input_yield]
    title = ['Overflow FP Accu Yield', 'Verified FP Accu Yield', 'Bad FP Accu Yield', 'Worse FP Accu Yield', 'No Input']
    percent = [overflow_accu_yield_rate, great_accu_yield_rate, bad_accu_yield_rate, worse_accu_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end

  def fp_daily_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    datetime = reports.first.published_at

    # overflow_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today > ?", 'ALL', station, datetime, 100.00).count
    # great_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 99.51, 100.00).count
    # bad_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 90.00, 99.50).count
    # worse_daily_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today >= ? AND yield_rate_today <= ?", 'ALL', station, datetime, 0.00, 89.99).count
    # no_input_yield = Report.where("config != ? AND station_name = ? AND published_at = ? AND yield_rate_today IS NULL", 'ALL', station, datetime).count
    
    overflow_daily_yield = reports.where("fp_yield_rate_today > ?", 100.00).count
    great_daily_yield = reports.where("fp_yield_rate_today >= ? AND fp_yield_rate_today <= ?", 99.51, 100.00).count
    bad_daily_yield = reports.where("fp_yield_rate_today >= ? AND fp_yield_rate_today <= ?", 90.00, 99.50).count
    worse_daily_yield = reports.where("fp_yield_rate_today >= ? AND fp_yield_rate_today <= ?", 0.00, 89.99).count
    no_input_yield = reports.where("fp_yield_rate_today IS NULL").count

    overflow_daily_yield_rate = ((overflow_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    great_daily_yield_rate = ((great_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_daily_yield_rate = ((bad_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_daily_yield_rate = ((worse_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_daily_yield, great_daily_yield, bad_daily_yield, worse_daily_yield, no_input_yield]
    title = ['Overflow FP Daily Yield', 'Verified FP Daily Yield', 'Bad FP Daily Yield', 'Worse FP Daily Yield', 'No Input']
    percent = [overflow_daily_yield_rate, great_daily_yield_rate, bad_daily_yield_rate, worse_daily_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end
end
