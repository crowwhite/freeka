#Fixed -> Move all requests of admin in admin namespace.
class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    #Fixed -> Create a scope in model to find root_categories.
    #Fixed -> Remove js and json request.
    @categories = Category.parent_categories
    respond_with(@categories)
  end

  def show
    #Fixed -> Remove json request.
    respond_with(@category)
  end

      #Fixed -> populate_parent_categories is not required. Use directly in view.
      #Fixed -> populate_parent_categories is not required. Use directly in view.

  private
    #Fixed -> Use find_by_id, find gives exception if there is no record. Also handle when no record found
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        flash[:notice] = 'Category not found'
        redirect_to categories_path
      end
    end
end
