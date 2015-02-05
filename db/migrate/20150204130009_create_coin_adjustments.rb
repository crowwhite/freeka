class CreateCoinAdjustments < ActiveRecord::Migration
  def change
    create_table :coin_adjustments do |t|
      t.references :adjustable, polymorphic: true
      t.references :person
      t.integer :coins

      t.timestamps
    end
  end
end
