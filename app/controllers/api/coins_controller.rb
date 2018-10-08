class Api::CoinsController < ApplicationController
  before_action: :set_coin, only: [:show, :update, :destroy]
  BASE_URL = 'https://api.coinmarketcap.com/v2/'

  def index
    render json: current_user.coins
  end

  def show
    render json: @coin
  end

  def create
    cmc_id = params[:coin].upcase
    listing = HTTParty.get("#{BASE_URL}listings")
    listing = listing['data'].find { |l| l['symbol'] == cmc_id }
    res = HTTParty/get("#{BASE_URL}/ticker/#{listing['id']}")
    if coin = Coin.create_by_cmc_id(res)
      watched = WatchedCoin.find_or_create_by(coin_id: coin.id, user_id: current_user.id)
      watched.update(initial_price: coin.price) if watched.initial_price.nill?
      render json: coin
    else 
      render json: { errors: 'Coin Not Found'}, status: 422
    end 
  end

  def update
    current_user.watched_coins.find_by(coin_id: @coin.id).destroy
  end

  def destroy
    @coin.destroy
  end

  private
    def set_coin
      @coin = Coin.find(params[:id])
    end   

end
