class Lottery < ApplicationRecord
  validates :name, presence: true

  has_many :rarities, dependent: :delete_all
  has_many :results

  def self.items?(lottery)
    items = []
    lottery.rarities.map {|rarity| items << rarity.items }
    result = items.flatten.present? ? true : false
    return result
  end
end
