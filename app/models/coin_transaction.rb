class CoinTransaction < ActiveRecord::Base
  COIN_PRICE = 100 # in cents

  def self.process(no_of_coins, credit_card_reference)
    response = GATEWAY.purchase(no_of_coins * COIN_PRICE, credit_card_reference)
    create(
      coins: no_of_coins,
      amount: no_of_coins * COIN_PRICE,
      success: response.success?,
      reference: response.authorization,
      action: 'purchase',
      test: ActiveMerchant::Billing::Base.mode == :test
    )
  end
end
