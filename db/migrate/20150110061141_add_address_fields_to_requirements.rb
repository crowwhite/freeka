class AddAddressFieldsToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :street, :string, default: '', null: false
    add_column :requirements, :city, :string, default: '', null: false
    add_column :requirements, :country_code, :string, default: '', null: false
    add_column :requirements, :state_code, :string, default: '', null: false
  end
end
