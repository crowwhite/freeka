class DonorRequirement < ActiveRecord::Base
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
        add_comment_on_requirement('I have donted the item.')
      end
      transitions from: :interested, to: :donated
    end

  end

  private

    #FIXME_AB: method name is not good. what to prevent?
    def prevent_if_fulfilled
      if requirement.fulfilled?
        #FIXME_AB: Message is not clear
        errors.add(:base, 'You cannot remove interest from or donate to successful donation.')
        false
      else
        true
      end
    end

    #FIXME_AB: Method naming issues
    def add_comment_on_requirement(comment = nil)
      requirement.comments.create(content: comment || 'I have withdrawn interest from this request.', user_id: self.donor_id)
    end
end
