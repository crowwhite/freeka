require 'rails_helper'

describe Attachment do
  describe 'associations' do
    it { should belong_to(:attacheable) }
    it { should have_attached_file(:attachment) }
  end

  describe 'validations' do
    it { should validate_attachment_content_type(:attachment).
                  allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc") }
    it { should validate_attachment_size(:attachment).
                  less_than(10.megabytes) }
  end
end