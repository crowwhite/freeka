class DonorMailer < ActionMailer::Base
  #FIXME_AB: Don't hard code this email. we may have different email in different envs. This email should come from env. specific constants or it should be configurable 
  default from: 
  #FIXME_AB: try to use email layout for common header footer.

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