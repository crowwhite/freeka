class AddCaptionToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :caption, :string, default: '', null: false
  end
end
