class Admin::CategoriesController < Admin::BaseController
  layout 'admin'

  before_action :set_category, only: [:show, :edit, :update, :toggle_status]

  def index
    @categories = Category.roots.order(:name).includes(:sub_categories).page params[:page]
  end

  def new
    @category = Category.new
  end

  def new_sub_category
    @category = Category.new
    @is_sub_category = true
    render :new
  end

  def edit
    if @category.parent_id
      @is_sub_category = true
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      # TODO: Notice?? Add flash messages every where in app on succes / failure
      flash[:notice] = 'Category saved successfully'
      @category.is_sub_category ? redirect_to(admins_categories_path) : redirect_to(admins_sub_categories_path)
    else
      if @category.is_sub_category
        @is_sub_category = true
      end
      # TODO: Can use symbol.
      # Fixed
      flash.now[:alert] = 'Some errors were encountered in Category creation'
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category successfully updated'
      redirect_to admins_categories_path
    else
      flash.now[:alert] = 'Some errors were encountered in Category updation'
      render :edit
    end
  end

  def toggle_status
    # TODO: what if update fails? Think of all cases while writing any code.
    # Fixed
    if @category.update(enabled: category_params[:enabled])
      flash.now[:notice] = "Category #{ @category.enabled ? :Enabled : :Disabled }"
    else
      flash.now[:alert] = "Couldn't change state of Category"
    end
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        # TODO: Should not be a notice.
        # Fixed
        flash[:alert] = 'Category not found'
        redirect_to admins_categories_path
      end
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled, :is_sub_category)
    end
end
