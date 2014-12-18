class DonorMailer < ActionMailer::Base
  default from: 'mail2freeka@gmail.com'

  def thank_interested_donor(donor, requirement)
    @donor = donor
    @requirement = requirement
    mail to: @donor.email, subject: 'Thanks for showing Interest'
  end

  def thank_fulfilling_donor(donor, requirement)
    @donor = donor
    @requirement = requirement
    mail to: @donor.email, subject: 'Whole hearted thanks for your donation'
  end
end