class CoinAdjustment < ActiveRecord::Base
  belongs_to :person

  after_create :credit_coins_to_user

  def self.buy(no_of_coins, credit_card_reference, user)
    response = CoinTransaction.process(no_of_coins, credit_card_reference)
    adjustment = new(
        adjustable_id: response.id,
        adjustable_type: 'Recharge',
        person_id: user.id,
        coins: no_of_coins
      )
    if response.success?
      adjustment.save
    else
      adjustment.errors.add(:base, response.message)
    end
    adjustment
  end

  private

    def credit_coins_to_user
      person.update(coins: person.coins + coins)
    end
end
