class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donor_requirements do |t|
      t.integer :donor_id, null: false
      t.references :requirement, index: true, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :donor_requirements, :donor_id
  end
end
