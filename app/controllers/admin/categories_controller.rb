class Admin::CategoriesController < Admin::BaseController
  layout 'admin'

  before_action :set_category, only: [:show, :edit, :update, :toggle_status]

  respond_to :html, :js


  def index
    @categories = Category.root.includes(:sub_categories)
    respond_with(@categories)
  end

  def new
    @category = Category.new
  end

  def show
    respond_with(@category)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admins_categories_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admins_categories_path
    else
      render 'edit'
    end
  end

  def toggle_status
    status = category_params[:enabled] == 'true'
    @category.update_column(:enabled, status)
    if @category.parent?
      @category.sub_categories.where("enabled = ?", !status).each do |sub_category|
        sub_category.update_column(:enabled, status)
      end
    end
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        flash[:notice] = 'Category not found'
        redirect_to admins_categories_path
      end
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled)
    end
end
