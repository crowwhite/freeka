require 'rails_helper'

describe Attachment do
  describe 'associations' do
    it { should belong_to(:attacheable) }
    it { should have_attached_file(:attachment) }
  end

  describe 'validations' do
    it { should validate_attachment_content_type(:attachment).
                  allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "text/html", "application/doc") }
    # it { should validate_attachment_size(:attachment).greater_than(0).
                  # less_than(10.megabytes) }
  end

  describe 'test url when called on image' do
    let(:image) { Attachment.new(attachment: File.new(Rails.root.join('public/give-charity-donations.jpg'), 'r')) }

    context 'when size thumb is passed' do
      it 'should return url for thumb size' do
        expect(image.url(:thumb)).to match(/\/system\/attachments\/attachments\/\/thumb\/give-charity-donations.jpg*/)
      end
    end

    context 'when size medium is passed' do
      it 'should return url for medium size' do
        expect(image.url(:medium)).to match(/\/system\/attachments\/attachments\/\/medium\/give-charity-donations.jpg*/)
      end
    end

    context 'when no size is passed' do
      it 'should return url for original size' do
        expect(image.url).to match(/\/system\/attachments\/attachments\/\/original\/give-charity-donations.jpg*/)
      end
    end
  end

  describe 'test url when called on file other than image' do
    let(:file) { Attachment.new(attachment: File.new(Rails.root.join('public/robots.txt'), 'r')) }
    it 'should return url for original file irrespective of any size passed' do
      expect(file.url(:medium)).to match(/\/system\/attachments\/attachments\/\/original\/robots.txt*/)
    end
  end
end