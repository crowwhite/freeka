class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :person
      t.boolean :active
      t.integer :last_numbers
      t.string :reference
      t.date :expiration_date
      t.string :type

      t.timestamps
    end
  end
end
