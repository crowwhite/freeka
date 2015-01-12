class AddCompositeIndexToAttachment < ActiveRecord::Migration
  def change
    add_index :attachments, [:attacheable_type, :attacheable_id]
  end
end
