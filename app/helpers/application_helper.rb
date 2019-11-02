module ApplicationHelper
  # For breadcrumbs
  def ensure_navigation
    @navigation ||= [ { :title => 'Home', :url => '/' } ]
  end

  def navigation_add(title, url)
  	ensure_navigation << { :title => title, :url => url }
  end

  def render_navigation
  	render :partial => 'layouts/navigation', :locals => { :nav => ensure_navigation }
  end

  def render_yield_rate(yield_rate)
    render :partial => 'layouts/yield_rate', locals: { yield_rate: yield_rate }
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def get_config_counts(report)
    return Report.where('post_id = ? AND config != ? AND station_name = ? AND published_at = ?', 
      report.post_id, 'ALL', report.station_name, report.published_at).count
  end

  def get_main_mini_config_counts(report)
    return Report.where('post_id = ? AND config IN (?) AND station_name = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?', 
      report.post_id, report.config.split(';'), report.station_name, report.p_year, report.p_month, report.p_mday, report.p_hour).count
  end

  def total_yield_counts(post)
    return post.reports.where(config: 'ALL').count
  end
end
