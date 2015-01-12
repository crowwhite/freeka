class AddIndexInAttachments < ActiveRecord::Migration
  def change
    add_index :attachments, :attacheable_id
    add_index :attachments, :attacheable_type
    add_index :attachments, :attacheable_sub_type
  end
end
