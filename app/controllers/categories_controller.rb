#TODO -> Move all requests of admin in admin namespace.
class CategoriesController < ApplicationController
  before_action :allow_only_admin, only: [:new, :edit, :create, :update, :destroy]
  before_action :populate_parent_categories, only: [:new, :edit]
  after_action :populate_parent_categories, only: :create
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  def index
    #TODO -> Create a scope in model to find root_categories.
    #TODO -> Remove js and json request.
    @categories = Category.where("parent_id is NULL").order(:name)
    respond_with(@categories)
  end

  def show
    #TODO -> Remove json request.
    respond_with(@category)
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      #TODO -> populate_parent_categories is not required. Use directly in view.
      populate_parent_categories
      render 'edit'
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path
    else
      #TODO -> populate_parent_categories is not required. Use directly in view.
      populate_parent_categories
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  private
    def populate_parent_categories
      @parent_categories = Category.select(:id, :name).where(:parent_id => nil)
    end
    
    #TODO -> Use find_by_id, find gives exception if there is no record. Also handle when no record found
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled)
    end
end
