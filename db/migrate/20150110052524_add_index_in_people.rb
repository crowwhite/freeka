class AddIndexInPeople < ActiveRecord::Migration
  def change
    add_index :people, :type
  end
end
