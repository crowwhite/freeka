class AddAttachmentInfoFileToRequirements < ActiveRecord::Migration
  def self.up
    change_table :requirements do |t|
      t.attachment :info_file
    end
  end

  def self.down
    remove_attachment :requirements, :info_file
  end
end
