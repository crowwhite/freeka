class CreateCategoryRequirements < ActiveRecord::Migration
  def change
    create_table :category_requirements do |t|
      t.references :category, index: true
      t.references :requirement, index: true, null: false

      t.timestamps
    end
  end
end
