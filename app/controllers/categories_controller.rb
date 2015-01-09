class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.roots.enabled.order(:name).includes(:enabled_sub_categories)
  end

  def sub_categories
    render partial: 'sub_categories', layout: false
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
      redirect_to categories_path, alert: 'Category not found' unless @category
    end
end
