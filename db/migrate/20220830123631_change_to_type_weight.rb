class ChangeToTypeWeight < ActiveRecord::Migration[6.0]
  def change
    change_column :rarities, :weight, :float
  end
end
