class CreateRarities < ActiveRecord::Migration[6.0]
  def change
    create_table :rarities do |t|

      t.string :name,         null: false
      t.references :lottery,  foreign_key: true
      t.integer :weight,      null: false
      t.timestamps
    end
  end
end
