class ReverseIntegerToWeight < ActiveRecord::Migration[6.0]
  def change
    change_column :rarities, :weight, :integer
  end
end
