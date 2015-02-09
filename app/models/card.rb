class Card < ActiveRecord::Base

  attr_accessor :first_name, :last_name, :number, :card_type, :year, :month, :cvv, :stored_card

  belongs_to :person

  before_create :disable_active_card, :store_card_in_vault, :store_card_reference

  private

    def disable_active_card
      person.cards.find_by(active: true).try(:update, active: false)
    end

    def store_card_in_vault
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name=> first_name,
        :last_name=> last_name,
        :month=> month,
        :year=> year,
        :type=> card_type,
        :number=> number,
        :verification_value=> cvv
      )
      @stored_card = GATEWAY.store(credit_card)
    end

    def store_card_reference
      self.active = true
      self.last_numbers = stored_card.params["braintree_customer"]["credit_cards"][0]["masked_number"].last(4)
      self.reference = stored_card.authorization
      self.card_type = stored_card.params["braintree_customer"]["credit_cards"][0]["card_type"]
    end
end
