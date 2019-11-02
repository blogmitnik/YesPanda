class Api::V1::StationsController < Api::ApiController
  doorkeeper_for :all

  def index
    page = (params[:page] || 1).to_i
    per_page = 25
    expires_in 5.seconds
    @post = current_user.posts.find_by_id(params[:my_post_id])
    if @post.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested station list does not exist or you don't have permission to see it."
      )
      return
    end
    if page > 1 || stale?(last_modified: @post.stations.maximum(:updated_at))
      @stations = @post.stations.order("updated_at ASC").page(page).per(per_page)
    end
  end

  def show
  	@post = current_user.posts.find_by_id(params[:my_post_id])
  	@station = @post.stations.find_by_id(params[:id])
  	if @post.nil? || @station.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested station does not exist or you don't have permission to see it."
      )
      return
    end
    expires_in 5.seconds
    fresh_when @station
  end
end
