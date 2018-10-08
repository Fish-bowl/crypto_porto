class Coin < ApplicationRecord
  validates_uniqueness_of :cmc_id, :name, :symbol, { case_sensitive: false}
  validates_presence_of :cmc_id, :name, :symbol

  has_many :watched_coins, dependent: :destroy
  has_many :users, through: :watched_coins

  def self.create_by_cmc_id(res)
    match = res['data'].with_indifferent_access
    coin_params = {
      name: match[:name],
      symbol: match[:symbol],
      cmc_id: match[:id]
    }
    Coin.find_or_create_by(coin_params) do |coin|
      coin.price = match[:quotes][:USD][:price]
      coin.last_fetched = DateTime.now
    end
  end

end
