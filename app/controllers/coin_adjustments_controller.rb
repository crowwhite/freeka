class CoinAdjustmentsController < ApplicationController

  def index
  end

  def new
    @coin_adjustment = CoinAdjustment.new
  end

  def create
    debugger
    if params[:card_id].blank?
      credit_card = Card.create(params[:card], current_user)
    else
      credit_card = Card.find_by(id: params[:card_id])
    end
    adjustment = CoinAdjustment.buy(params[:coin_adjustment][:coins].to_i, credit_card.reference, current_user)
    if adjustment.errors.any?
      flash.now[:error] = "Transaction could not be completed"
      render :new
    else
      redirect_to current_user, notice: "Coins added successfully"
    end
  end

end