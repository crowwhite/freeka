class AddcoinToPeople < ActiveRecord::Migration
  def change
    add_column :people, :coins, :integer, default: 0
  end
end
