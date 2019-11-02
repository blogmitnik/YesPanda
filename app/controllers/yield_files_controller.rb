class YieldFilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @product = Product.find(params[:product_id])
    @post = Post.find(params[:my_post_id])
    @files = @post.yield_files.order("created_at DESC")
  end

  def show
    @product = Product.find(params[:product_id])
    @post = Post.find(params[:my_post_id])
    @file = @post.yield_files.find_by_id(params[:id])
    if @file
      if @file.file_name.include? "Sum-Main"
        @reports = @post.report_mains.where(yield_file_id: @file).order("seqno ASC").page(params[:page])
      elsif @file.file_name.include? "Sum-Mini"
        @reports = @post.report_minis.where(yield_file_id: @file).order("seqno ASC").page(params[:page])
      else
        @reports = @post.reports.where(yield_file_id: @file).order("seqno ASC").page(params[:page])
      end
    end
  end

  def destroy
    @product = Product.find(params[:product_id])
  	@post = Post.find(params[:my_post_id])
    @reports = @post.reports.order("published_at ASC").page(params[:page])
  	@file = @post.yield_files.find(params[:id])
    @file.destroy
    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to product_my_post_path(@product, @post), notice: "Successfully removed '#{@file.file_name}'" }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    @product = Product.find(params[:product_id])
    @post = Post.find(params[:my_post_id])
    if params[:file_ids]
      YieldFile.where(id: params[:file_ids]).destroy_all
      #YieldFile.destroy_all(id: params[:file_ids])
      respond_to do |format|
        format.js { head :ok }
        format.html { redirect_to product_my_post_yield_files_path(@product, @post), notice: "Successfully removed #{params[:file_ids].count} selected files" }
        format.json { head :no_content }
      end
    end
  end
end
