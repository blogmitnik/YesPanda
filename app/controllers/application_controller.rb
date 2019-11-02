class ApplicationController < ActionController::Base
  protect_from_forgery

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  rescue_from Exception, with: :rescue500
  rescue_from Forbidden, with: :rescue403
  rescue_from IpAddressRejected, with: :rescue403
  rescue_from ActionController::RoutingError, with: :rescue404
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from Timeout::Error, with: :rescue524

  private

  def get_latest_time_yield(post, reports)
    last_record = post.reports.where(config: 'ALL').order("published_at DESC").first
    datetime = DateTime.parse(last_record.published_at.to_s)
    reports = reports.where('p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?', 
        datetime.year, datetime.month, datetime.mday, datetime.hour)
    return reports.order("seqno ASC")
  end

  def get_target_date_yield(post, reports, build, target_date)
    if build == 'main'
      last_record = post.report_mains.order("published_at DESC").first
    elsif build == 'mini'
      last_record = post.report_minis.order("published_at DESC").first
    else
      last_record = reports.where(config: 'ALL', p_year: target_date.to_date.year, p_month: target_date.to_date.month, p_mday: target_date.to_date.day).order("published_at DESC").first
    end
    datetime = DateTime.parse(last_record.published_at.to_s)
    if last_record.p_hour.between?(6, 23)
      reports = reports.where('p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?', 
        datetime.year, datetime.month, datetime.mday, 6)
    elsif last_record.p_hour.between?(0, 5)
      # Show reports with timestamp after 6am yesterday to 5am today
      reports = reports.where('p_year = ? AND p_month = ? AND ((p_mday = ? AND p_hour >= ?) OR (p_mday = ? AND p_hour < ?))', 
        datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6, datetime.day, 6)
    end

    if params[:my_post_id].present? # For station page
      if params[:data_period].present? && params[:data_period] == "hourly"
        return reports
      else
        # Show only latest time of data
        latest_date = reports.maximum('published_at')
        return reports = reports.where(published_at: latest_date)
      end
    else
      # For showing only latest time of data
      latest_date = reports.maximum('published_at')
      return reports = reports.where(published_at: latest_date)
    end
  end

  def get_today_yield(post, reports, build)
    if build == 'main'
      last_record = post.report_mains.order("published_at DESC").first
    elsif build == 'mini'
      last_record = post.report_minis.order("published_at DESC").first
    else
      last_record = post.reports.where(config: 'ALL').order("published_at DESC").first
    end
    datetime = DateTime.parse(last_record.published_at.to_s)
    if last_record.p_hour.between?(6, 23)
      reports = reports.where('p_year = ? AND p_month = ? AND p_mday = ? AND p_hour >= ?', 
        datetime.year, datetime.month, datetime.mday, 6)
    elsif last_record.p_hour.between?(0, 5)
      # Show reports with timestamp after 6am yesterday to 5am today
      reports = reports.where('p_year = ? AND p_month = ? AND ((p_mday = ? AND p_hour >= ?) OR (p_mday = ? AND p_hour < ?))', 
        datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6, datetime.day, 6)
    end
    
    if params[:my_post_id].present? # For station page
      if params[:data_period].present? && params[:data_period] == "hourly"
        return reports
      else
        # Show only latest time of data
        latest_date = reports.maximum('published_at')
        return reports = reports.where(published_at: latest_date)
      end
    else
      # For showing only latest time of data
      latest_date = reports.maximum('published_at')
      return reports = reports.where(published_at: latest_date)
    end
  end

  def get_yesterday_yield(post, reports, build)
    if build == 'main'
      last_record = post.report_mains.order("published_at DESC").first
    elsif build == 'mini'
      last_record = post.report_minis.order("published_at DESC").first
    else
      last_record = post.reports.where(config: 'ALL').order("published_at DESC").first
    end
    datetime = DateTime.parse(last_record.published_at.to_s)
    if last_record.p_hour.between?(6, 23)
      # Show reports with timestamp after 6am yesterday to 5am today
      reports = reports.where('p_year = ? AND p_month = ? AND ((p_mday = ? AND p_hour >= ?) OR (p_mday = ? AND p_hour < ?))', 
        datetime.yesterday.year, datetime.yesterday.month, datetime.yesterday.day, 6, datetime.day, 6)
    elsif last_record.p_hour.between?(0, 5)
      # Show reports with timestamp after 6am the day before yesterday to 5am yesterday
      reports = reports.where('p_year = ? AND p_month = ? AND ((p_mday = ? AND p_hour >= ?) OR (p_mday = ? AND p_hour < ?))', 
        (datetime - 2).year, (datetime - 2).month, (datetime - 2).day, 6, datetime.yesterday.day, 6)
    end
    
    if params[:my_post_id].present?
      if params[:data_period].present? && params[:data_period] == "hourly"
       return reports
     else
      # Show only latest time of data
      latest_date = reports.maximum('published_at')
      return reports = reports.where(published_at: latest_date)
     end
    else
      # For showing only latest time of data
      latest_date = reports.maximum('published_at')
      return reports = reports.where(published_at: latest_date)
    end
  end

  def rescue400(e)
    @exception = e
    error_info = {
      :error => "Bad request",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    respond_to do |format|
      format.json{ render json: error_info.to_json, status: 400 }
      format.html{ render 'errors/bad_request', status: 400 }
    end
  end

  def rescue403(e)
    @exception = e
    error_info = {
      :error => "Unauthorized",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    respond_to do |format|
      format.json{ render json: error_info.to_json, status: 403 }
      format.html{ render 'errors/forbidden', status: 403 }
    end
  end

  def rescue404(e)
    @exception = e
    error_info = {
      :error => "Resource not found",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    respond_to do |format|
      format.json{ render json: error_info.to_json, status: 404 }
      format.html{ render 'errors/not_found', status: 404 }
    end
  end

  def rescue500(e)
    @exception = e
    error_info = {
      :error => "Internal server error",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    respond_to do |format|
      format.json{ render json: error_info.to_json, status: 500 }
      format.html{ render 'errors/internal_server_error', status: 500 }
    end
  end

  def rescue524(e)
    @exception = e
    error_info = {
      :error => "A timeout occurred",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
    respond_to do |format|
      format.json{ render json: error_info.to_json, status: 524 }
      format.html{ render 'errors/timeout_occurred', status: 524 }
    end
  end
end
