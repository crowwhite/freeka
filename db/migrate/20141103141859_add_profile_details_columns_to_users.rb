class AddProfileDetailsColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, default: ''
    add_column :users, :about_me, :text
    add_column :users, :contact_no, :integer, default: 0
    add_column :users, :address, :text
  end
end
