class AddColumnAttachableSubTypeToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :attacheable_sub_type, :string, default: :File
  end
end
