class Item < ApplicationRecord
  validates :name, presence: true
  
  belongs_to :rarity
  has_many :results
end
