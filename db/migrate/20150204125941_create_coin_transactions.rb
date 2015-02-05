class CreateCoinTransactions < ActiveRecord::Migration
  def change
    create_table :coin_transactions do |t|
      t.integer :coins
      t.integer :amount
      t.boolean :success
      t.string :reference
      t.text :message
      t.string :action
      t.text :params
      t.boolean :test
      t.references :coin_adjustment

      t.timestamps
    end
  end
end
