class Admin::CategoriesController < Admin::BaseController
  layout 'admin'

  before_action :set_category, only: [:show, :edit, :update, :toggle_status]

  respond_to :html, :js


  def index
    @categories = Category.root.order(:name).includes(:sub_categories).page params[:page]
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
      # TODO: Notice?? Add flash messages every where in app on succes / failure
      redirect_to admins_categories_path
    else
      # TODO: Can use symbol.
      render 'edit'
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
    # TODO: what if update fails? Think of all cases while writing any code.
    @category.update(category_params)
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        # TODO: Should not be a notice.
        flash[:notice] = 'Category not found'
        redirect_to admins_categories_path
      end
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled)
    end
end
