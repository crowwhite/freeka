module RequirementASM
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :status, enum: true do
      state :pending, initial: true
      state :in_process
      state :fulfilled

      event :process do
        transitions from: :pending, to: :in_process
      end

      event :unprocess do
        transitions from: :in_process, to: :pending
      end

      event :fulfill do
        after do
          # TODO: Module should never be dependent on including classes.
          update_donor_and_reject_interested_donors
        end
        before do
          !pending?
        end
        transitions from: :in_process, to: :fulfilled
      end
    end
  end
end