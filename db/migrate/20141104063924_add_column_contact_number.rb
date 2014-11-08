class AddColumnContactNumber < ActiveRecord::Migration
  def change
    add_column :users, :contact_no, :integer, limit: 8
  end
end
