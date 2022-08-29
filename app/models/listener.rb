class Listener < ApplicationRecord
  validates :name, presence: true

  has_many :results, dependent: :delete_all
end
