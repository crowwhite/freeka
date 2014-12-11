class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :requirement, index: true

      t.timestamps
    end
  end
end
