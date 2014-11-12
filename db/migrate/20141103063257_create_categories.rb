class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :category, index: true, null: true
      t.boolean :enabled, default: true, null: false


      t.timestamps
    end
  end
end
