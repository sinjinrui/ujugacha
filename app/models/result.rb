class Result < ApplicationRecord
  belongs_to :lottery
  belongs_to :listener
  belongs_to :item
end
