class Admin::SubCategoriesController < Admin::BaseController
  layout 'admin'
  #TODO: No need of this.....

  def index
    @categories = Category.children.order(:name).includes(:parent_category).page params[:page]
    render 'admin/categories/index'
  end

  def new
    @category = Category.new
    @is_sub_category = true
    render 'admin/categories/new'
  end
end