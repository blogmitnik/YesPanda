class StationsController < ApplicationController
  before_filter :authenticate_user!

  def show
  	page = (params[:page] || 1).to_i
  	@product = Product.find(params[:product_id])
  	@post = Post.find(params[:my_post_id])
    @station = @post.stations.find(params[:id])
    # Get reports by date is parameters present
    build = params[:build].to_s
    if build == 'main'
      reports_by_all_config = @station.report_mains
    elsif build == 'mini'
      reports_by_all_config = @station.report_minis
    else
      reports_by_all_config = @station.reports.where(config: 'ALL')
    end

    if params[:date] == 'today'
      @reports_for_cart = get_today_yield(@post, reports_by_all_config, build)
  	elsif params[:date] == 'yesterday'
  	  @reports_for_cart = get_yesterday_yield(@post, reports_by_all_config, build)
    elsif params[:date_range].present?
      # For search feature! Show station's data with specific date from search box
      the_date = params[:date_range]
      @reports_for_cart = get_target_date_yield(@post, reports_by_all_config, build, the_date)
    else # Same as 'Today'
      @reports_for_cart = get_today_yield(@post, reports_by_all_config, build)
	  end
    reports_tmp = @reports_for_cart
    @reports_for_cart = reports_tmp.order("published_at ASC")
    @reports = reports_tmp.order("published_at DESC").page(page)
  end
end
