class CardsController < ApplicationController

  def new
    @card = Card.new
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      redirect_to root_path, notice: 'Card has been successfully added'
    else
      render :new
    end
  end

  private

    def card_params
      params.require(:card).permit(:number, :card_type, :first_name, :last_name, :CVV, :month, :year)
    end
end