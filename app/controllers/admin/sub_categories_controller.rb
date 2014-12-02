class Admin::SubCategoriesController < Admin::BaseController
  layout 'admin'
  #TODO: No need of this.
  append_view_path 'app/views/admin/categories'

  def index
    @categories = Category.children.order(:name).includes(:parent_category).page params[:page]
    render '/index'
  end
end