class Admin::SubCategoriesController < Admin::BaseController
  layout 'admin'
  #TODO: No need of this.
  # We are reusing the views of categories, so we have to write admin/categories/:view again and again
  # hence we append a view path and just write the name of path.
  append_view_path 'app/views/admin/categories'

  def index
    @categories = Category.children.order(:name).includes(:parent_category).page params[:page]
    render '/index'
  end
end