class Admin::CategoriesController < Admin::BaseController
  #TODO -> Remove destroy
  #TODO -> Move this before_filter into base_controller
  #Fixed
  before_action :set_category, only: [:show, :edit, :update, :toggle_status]

  respond_to :html, :js


  def index
    @categories = Category.root
    respond_with(@categories)
  end

  def new
    @category = Category.new
  end

  #TODO -> This action is not required.
  #Fixed -- removed new_sub_category

  def show
    respond_with(@category)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      #TODO -> Please check I think this instance variable is not required.
      #Fixed -- removed
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def toggle_status
    #TODO -> I think validation and callback execution is not required.
    #Fixed -- 'toggle' skips callbacks and 'toggle!' skips validation but update_column skips both
    @category.update_column(:enabled, category_params[:enabled] == 'true')
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        flash[:notice] = 'Category not found'
        redirect_to admin_categories_path
      end
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled)
    end
end
