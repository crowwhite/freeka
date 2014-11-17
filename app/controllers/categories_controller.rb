class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.enabled.includes(:enabled_sub_categories)
    respond_with(@categories)
  end

  def show
    respond_with(@category)
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        flash[:notice] = 'Category not found'
        redirect_to categories_path
      end
    end
end
