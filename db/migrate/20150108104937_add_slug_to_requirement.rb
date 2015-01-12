class AddSlugToRequirement < ActiveRecord::Migration
  def change
    add_column :requirements, :slug, :string
    add_index :requirements, :slug
  end
end
