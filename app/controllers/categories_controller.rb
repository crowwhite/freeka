#TODO -> Move all requests of admin in admin namespace.
class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    #TODO -> Create a scope in model to find root_categories.
    #TODO -> Remove js and json request.
    @categories = Category.parent_categories
    respond_with(@categories)
  end

  def show
    #TODO -> Remove json request.
    respond_with(@category)
  end

      # TODO -> populate_parent_categories is not required. Use directly in view.
      #TODO -> populate_parent_categories is not required. Use directly in view.

  private
    #TODO -> Use find_by_id, find gives exception if there is no record. Also handle when no record found
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        flash[:notice] = 'Category not found'
        redirect_to categories_path
      end
    end
end
