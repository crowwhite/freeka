class AddAttachmentInfoFileToAttachments < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.attachment :desc_file
    end
  end

  def self.down
    remove_attachment :attachments, :desc_file
  end
end
