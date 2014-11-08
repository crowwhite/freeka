class ChangeContactNoColumnType < ActiveRecord::Migration
  def change
    change_column :people, :contact_no, :string
  end
end
