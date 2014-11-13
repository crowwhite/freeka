class AddProfileDetailsColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :people, :name, :string, default: ''
    add_column :people, :about_me, :text
    add_column :people, :contact_no, :string
    add_column :people, :address, :text
    add_column :people, :type, :string, default: 'User'
    add_column :people, :enabled, :boolean, default: true, null: false
  end
end
