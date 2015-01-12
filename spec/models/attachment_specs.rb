require 'rails_helper'

describe Attachment do
  let(:image) { Attachment.new(attachment: File.new(Rails.root.join('public/give-charity-donations.jpg'), 'r')) }
  let(:file) { Attachment.new(attachment: File.new(Rails.root.join('public/robots.txt'), 'r')) }
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

  describe '#url' do

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
    it 'should return url for original file irrespective of any size passed' do
      expect(file.url(:medium)).to match(/\/system\/attachments\/attachments\/\/original\/robots.txt*/)
    end
  end

  describe '#is_image' do
    context 'when it is a image' do

      it 'should return true when type is jpg' do
        image.attachment_content_type = "image/jpg"
        expect(image.is_image).to eq(true)
      end

      it 'should return true when type is jpeg' do
        image.attachment_content_type = "image/jpeg"
        expect(image.is_image).to eq(true)
      end

      it 'should return true when type is png' do
        image.attachment_content_type = "image/png"
        expect(image.is_image).to eq(true)
      end

      it 'should return true when type is gif' do
        image.attachment_content_type = "image/gif"
        expect(image.is_image).to eq(true)
      end

    end

    context 'when it is not an image' do

      it 'should return false when type is txt' do
        expect(file.is_image).to eq(false)
      end

      it 'should return false when type is pdf' do
        file.attachment_content_type = "application/pdf"
        expect(file.is_image).to eq(false)
      end

    end
  end
end