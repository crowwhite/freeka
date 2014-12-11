class AddImageIdToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :image_id, :integer
  end
end
