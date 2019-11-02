
module StationsHelper
  def station_accu_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    build = reports.first.post_id
    datetime_start = reports.minimum('published_at')
    datetime_end = reports.maximum('published_at')

    if params[:data_period].present? && params[:data_period] == "hourly"
      # If parameter present, show each hour's report
      overflow_accu_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate > ?", datetime_start, datetime_end, 100.00).count
      great_accu_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", datetime_start, datetime_end, 99.51, 100.00).count
      bad_accu_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", datetime_start, datetime_end, 90.00, 99.50).count
      worse_accu_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate >= ? AND yield_rate <= ?", datetime_start, datetime_end, 0.00, 89.99).count
      no_input_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate IS NULL", datetime_start, datetime_end).count
    else
      # By default, only show latest hour's report for each day
      overflow_accu_yield = reports.where("yield_rate > ?", 100.00).count
      great_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 99.51, 100.00).count
      bad_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 90.00, 99.50).count
      worse_accu_yield = reports.where("yield_rate >= ? AND yield_rate <= ?", 0.00, 89.99).count
      no_input_yield = reports.where("yield_rate IS NULL").count
    end

    overflow_accu_yield_rate = ((overflow_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    great_accu_yield_rate = ((great_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_accu_yield_rate = ((bad_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_accu_yield_rate = ((worse_accu_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_accu_yield, great_accu_yield, bad_accu_yield, worse_accu_yield, no_input_yield]
    title = ['Overflow Accu Yield', 'Verified Accu Yield', 'Bad Accu Yield', 'Worst Accu Yield', 'No Input']
    percent = [overflow_accu_yield_rate, great_accu_yield_rate, bad_accu_yield_rate, worse_accu_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end

  def station_daily_yield_ratio_chart_data(reports)
    station = reports.first.station_name
    build = reports.first.post_id
    datetime_start = reports.minimum('published_at')
    datetime_end = reports.maximum('published_at')

    if params[:hourly_data].present? && params[:hourly_data] != ""
      # If parameter present, show each hour's report
      overflow_daily_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate_today > ?", datetime_start, datetime_end, 100.00).count
      great_daily_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", datetime_start, datetime_end, 99.51, 100.00).count
      bad_daily_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", datetime_start, datetime_end, 90.00, 99.50).count
      worse_daily_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate_today >= ? AND yield_rate_today <= ?", datetime_start, datetime_end, 0.00, 89.99).count
      no_input_yield = reports.where("published_at BETWEEN ? AND ? AND yield_rate_today IS NULL", datetime_start, datetime_end).count
    else
      # By default, only show latest hour's report for each day
      overflow_daily_yield = reports.where("yield_rate_today > ?", 100.00).count
      great_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 99.51, 100.00).count
      bad_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 90.00, 99.50).count
      worse_daily_yield = reports.where("yield_rate_today >= ? AND yield_rate_today <= ?", 0.00, 89.99).count
      no_input_yield = reports.where("yield_rate_today IS NULL").count
    end
    
    overflow_daily_yield_rate = ((overflow_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    great_daily_yield_rate = ((great_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    bad_daily_yield_rate = ((bad_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    worse_daily_yield_rate = ((worse_daily_yield.to_f / reports.count.to_f) * 100).round(2)
    no_input_yield_rate = ((no_input_yield.to_f / reports.count.to_f) * 100).round(2)

    range_array = [overflow_daily_yield, great_daily_yield, bad_daily_yield, worse_daily_yield, no_input_yield]
    title = ['Overflow Daily Yield', 'Verified Daily Yield', 'Bad Daily Yield', 'Worst Daily Yield', 'No Input']
    percent = [overflow_daily_yield_rate, great_daily_yield_rate, bad_daily_yield_rate, worse_daily_yield_rate, no_input_yield_rate]

    range_array.map.with_index do |range, index| {  
      value: range,
      label: title[index],
      percent: percent[index]
    }
    end
  end
end
