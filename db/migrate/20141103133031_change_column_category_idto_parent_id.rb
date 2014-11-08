class ChangeColumnCategoryIdtoParentId < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.rename :category_id, :parent_id
    end
  end
end
