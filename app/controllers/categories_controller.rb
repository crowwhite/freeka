class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.roots.enabled.order(:name).includes(:enabled_sub_categories)
    respond_with(@categories)
  end

  def show
    respond_with(@category)
  end

  def sub_categories
    render partial: 'sub_categories', layout: false
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      unless @category
        redirect_to categories_path, alert: 'Category not found'
      end
    end
end
