class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :title, index: true
      t.text :details
      t.date :expiration_date, index: true
      t.integer :location_id
      t.integer :requestor_id, index: true
      t.integer :status, default: 0, null: false
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end
  end
end
