class Api::V1::ReportsController < Api::ApiController
  doorkeeper_for :all

  def index
  	page = (params[:page] || 1).to_i
	per_page = 25
    expires_in 5.seconds
    
  	@post = current_user.posts.find_by_id(params[:my_post_id])
  	@station = @post.stations.find_by_id(params[:station_id]) if params[:station_id]
    if @post.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested yield report post does not exist or you don't have permission to see it."
      )
      return
    end
	
    if page > 1 || stale?(last_modified: @post.reports.maximum(:updated_at))
      # Ordered by parameters
      if !params[:sort].blank?
      	if (Report.column_names.include? params[:sort]) && (Report.sort_names.include? params[:sort])
      	  @reports = params[:station_id] ? @station.reports.order("#{params[:sort]} ASC").page(page).per(per_page) : @post.reports.order("#{params[:sort]} ASC").page(page).per(per_page)
      	else
      	  render_error(
        	:resource_not_found,
        	"Parameter Error",
        	"'#{params[:sort]}' is not a valid parameter."
      	  )
      	  return
      	end
      else
      	# Ordered by published_at as default
      	@reports = params[:station_id] ? @station.reports.order("published_at ASC").page(page).per(per_page) : @post.reports.order("published_at ASC").page(page).per(per_page)
  	  end
    end
  end

  def show
  	@post = current_user.posts.find_by_id(params[:my_post_id])
    @report = @post.reports.find_by_id(params[:id])
    if @report.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested yield data does not exist or you don't have permission to see it."
      )
      return
    end
    expires_in 5.seconds
    fresh_when @report, public: true
  end

  def destroy
    @post = current_user.posts.find_by_id(params[:my_post_id])
    @report = @post.reports.find_by_id(params[:id])
    if @report.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested yield data does not exist or you don't have permission to see it."
      )
      return
    end
    @report.destroy
    render :action => :show
  end
end
