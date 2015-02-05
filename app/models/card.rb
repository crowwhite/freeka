class Card < ActiveRecord::Base
  belongs_to :person

  def self.create(card_params, user)
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name=> card_params[:first_name],
        :last_name=> card_params[:last_name],
        :month=> card_params[:month],
        :year=> card_params[:year],
        :type=> card_params[:type],
        :number=> card_params[:number],
        :verification_value=> card_params[:CVV]
      )
    stored_card = GATEWAY.store(credit_card)
    super(
        last_numbers: stored_card.params["braintree_customer"]["credit_cards"][0]["masked_number"],
        reference: stored_card.authorization,
        card_type: stored_card.params["braintree_customer"]["credit_cards"][0]["card_type"],
        person_id: user.id
      )
  end
end
