class AddIndexInRequirements < ActiveRecord::Migration
  def change
    add_index :requirements, :requestor_id
  end
end
