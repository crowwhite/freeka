class AddColumnsToPeople < ActiveRecord::Migration
  def change
    change_table :people do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
    end
  end
end
