class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :categories, :name
    add_index :people,     :name
  end
end
