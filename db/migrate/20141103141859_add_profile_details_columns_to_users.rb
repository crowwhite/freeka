class AddProfileDetailsColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, default: ''
    add_column :users, :about_me, :text
    add_column :users, :contact_no, :string
    add_column :users, :address, :text
    add_column :users, :type, :string, default: 'User'
    add_column :users, :enabled, :boolean, default: true, null: false
  end
end
