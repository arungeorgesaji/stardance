class GuidesController < ApplicationController
  def index
    @guides_by_category = Guide.by_category
    @category_order = Guide.category_order
  end

  def show
    @guide = Guide.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound if @guide.nil?
  end
end
