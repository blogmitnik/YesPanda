class ProductsController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
  	@products = Product.find(:all, order: 'title')
  end

  def new
  	@product = Product.new
  end

  def create
  	@product = Product.new(params[:product])
    @product.user = current_user
    
    respond_to do |format|
      if @product.save
      	format.js
        format.html { redirect_to products_path, notice: "#{@product.title} was successfully created." }
        format.json { head :no_content }
      else
      	format.js
        format.html { render action: 'new' }
        format.json { head :no_content }
      end
    end
  end

  def destroy
  	@product = Product.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to products_path, notice: "#{@product.title} was removed." }
      format.json { head :no_content }
    end
  end

  def update_builds_selector
    @builds = Post.where(product_id: params[:product_id]).all
    #render partial: '/shared/builds_selector', object: @builds
  end

  def update_builds_menu
    @product = Product.find_by_title(params[:product_name].strip!)
    @builds = Post.where(product_id: @product).all
  end
end
