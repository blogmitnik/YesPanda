class ConfigsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	page = (params[:page] || 1).to_i
  	@product = Product.find(params[:product_id])
  	@post = @product.posts.find(params[:my_post_id])
    if params[:build] == 'main'
      @report = @post.report_mains.find(params[:report_id])
      @station = @report.station
      # Get records in Report model that CONFIG match MAIN config
      @reports_for_cart = @post.reports.where('config IN (?) AND station_name = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?', @report.config.split(';'), @report.station_name, @report.p_year, @report.p_month, @report.p_mday, @report.p_hour).order("published_at DESC")
    elsif params[:build] == 'mini'
      @report = @post.report_minis.find(params[:report_id])
      @station = @report.station
      # Get records in Report model that CONFIG match MINI config
      @reports_for_cart = @post.reports.where('config IN (?) AND station_name = ? AND p_year = ? AND p_month = ? AND p_mday = ? AND p_hour = ?', @report.config.split(';'), @report.station_name, @report.p_year, @report.p_month, @report.p_mday, @report.p_hour).order("published_at DESC")
    else
      @report = @post.reports.find(params[:report_id])
      @station = @report.station
      @reports_for_cart = @post.reports.where('config != ? AND station_name = ? AND published_at = ?', 'ALL', @report.station_name, @report.published_at).order("published_at DESC")
    end
  	@reports = @reports_for_cart.page(page)
  end
end
