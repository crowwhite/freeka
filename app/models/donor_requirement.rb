class DonorRequirement < ActiveRecord::Base

  attr_accessor :comment

  include AASM

  enum status: { interested: 0, donated: 1 }

  belongs_to :user, foreign_key: :donor_id
  belongs_to :requirement

  before_destroy :prevent_if_fulfilled
  after_destroy :add_comment_on_requirement

  aasm column: :status, enum: true, whiny_transitions: false do
    state :interested, initial: true
    state :donated

    event :donate, guard: :prevent_if_fulfilled do
      after do
        add_comment_on_requirement
        adjust_coins
      end
      transitions from: :interested, to: :donated
    end

  end

  private

    #FIXME_AB: method name is not good. what to prevent?
    # It seems meaningful when seen from calling end.
    def prevent_if_fulfilled
      if requirement.fulfilled?
        errors.add(:base, 'You cannot remove interest from successful donation.')
        false
      else
        true
      end
    end

    def add_comment_on_requirement
      unless requirement.comments.create(content: @comment, user_id: self.donor_id).persisted?
        errors.add(:base, 'comment cannot be blank')
        false
      else
        true
      end
    end

    def adjust_coins
      user.update(coins: user.coins + 5)
      user.coin_adjustments.create(coins: 5, adjustable_type: 'Donation', adjustable_id: id)
    end
end
