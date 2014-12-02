class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  #TODO: No need of this.
  # Fixed

  def index
    @categories = Category.roots.enabled.order(:name).includes(:enabled_sub_categories)
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
