class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city, index: true
      t.string :pin_code
      t.string :state_code, index: true
      t.string :country_code

      t.timestamps
    end
  end
end
