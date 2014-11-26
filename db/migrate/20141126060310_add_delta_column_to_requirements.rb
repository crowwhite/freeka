class AddDeltaColumnToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :delta, :boolean, default: true, null: false
  end
end
