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
        transitions from: :current, to: :donated
      end

      event :make_current do
        transitions from: :interested, to: :current
      end

      event :reject do
        transitions from: :current, to: :rejected
      end
    end
  end
end