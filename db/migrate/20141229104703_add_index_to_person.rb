class AddIndexToPerson < ActiveRecord::Migration
  def change
    add_index :people, :enabled
  end
end
