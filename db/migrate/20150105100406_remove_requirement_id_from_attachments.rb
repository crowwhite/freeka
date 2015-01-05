class RemoveRequirementIdFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :requirement_id
  end
end
