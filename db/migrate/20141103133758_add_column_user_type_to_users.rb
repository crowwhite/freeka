class AddColumnUserTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :string, default: 'user'
  end
end
