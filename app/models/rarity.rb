class Rarity < ApplicationRecord
  validates :name, presence: true
  validates :weight, presence: true

  belongs_to :lottery, optional: true
  has_many :items, dependent: :delete_all

end
