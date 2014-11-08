class CategoriesController < ApplicationController
  before_action :allow_only_admin, only: [:new, :edit, :create, :update, :destroy]
  before_action :populate_parent_categories, only: [:new, :edit]
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  def index
    @categories = Category.where("parent_id is NULL")
    respond_with(@categories)
  end

  def show
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
    @category.save
    redirect_to categories_path
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path
    else
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
    
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :parent_id, :enabled)
    end
end
