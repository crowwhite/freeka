class AddAttachmentInfoFileToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.attachment :description
    end
  end

  def self.down
    remove_attachment :attachments, :description
  end
end
