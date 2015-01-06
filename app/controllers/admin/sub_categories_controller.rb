#FIXME_AB: I don't think we need two controllers. one for category and other for sub category. The only difference is one has parent and other don't
class Admin::SubCategoriesController < Admin::BaseController

  def index
    @categories = Category.children.order(:name).includes(:parent_category).page params[:page]
  end

  def new
    @category = Category.new
    @is_sub_category = true
  end

  private
    def self.controller_path
      'admin/categories'
    end
end