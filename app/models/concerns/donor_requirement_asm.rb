module DonorRequirementASM
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :status, enum: true do
      state :interested, initial: true
      state :donated
      state :rejected
      state :current

      event :donate do
        after do
          requirement.update_donor_and_reject_interested_donors

        end
        transitions from: :current, to: :donated
      end

      event :show_interest do
        transitions from: :rejected, to: :interested
      end

      event :make_current do
        transitions from: :rejected, to: :current
        transitions from: :interested, to: :current
      end

      event :reject do
        transitions from: :current, to: :rejected
        transitions from: :interested, to: :rejected
      end
    end
  end
end