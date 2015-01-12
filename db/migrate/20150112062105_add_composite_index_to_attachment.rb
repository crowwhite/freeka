class AddCompositeIndexToAttachment < ActiveRecord::Migration
  def change
    add_index :attachments, [:attacheable_type, :attacheable_id]
    change_column_default :attachments, :caption, 'No caption available'
  end
end
