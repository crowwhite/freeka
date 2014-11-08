class AddColumnEnabledToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :enabled, :boolean, default: true, null: false
  end
end
