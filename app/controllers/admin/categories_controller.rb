class Admin::CategoriesController < Admin::BaseController

  before_action :set_category, only: [:show, :edit, :update, :toggle_status]

  def index
    @categories = Category.roots.order(:name).includes(:sub_categories).page params[:page]
  end

  def new
    @category = Category.new
  end

  def edit
    if @category.parent_id
      #FIXME_AB: Why do we need following instance variable. We can make it work without this. Please think
      @is_sub_category = true
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = 'Category saved successfully'
      @category.is_sub_category ? redirect_to(admins_sub_categories_path) : redirect_to(admins_categories_path)
    else
      if @category.is_sub_category
        #FIXME_AB: we don't need this instance variable
        @is_sub_category = true
      end
      flash.now[:alert] = 'Some errors were encountered in Category creation'
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admins_categories_path, notice: 'Category successfully updated'
    else
      flash.now[:alert] = 'Some errors were encountered in Category updation'
      render :edit
    end
  end

  def toggle_status
    if @category.update(enabled: category_params[:enabled])
      flash.now[:notice] = "Category #{ @category.enabled ? :Enabled : :Disabled }"
    else
      flash.now[:alert] = "Couldn't change state of Category"
    end
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      redirect_to admins_categories_path, alert: 'Category not found' unless @category
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled, :is_sub_category)
    end
end
