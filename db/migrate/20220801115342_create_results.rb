class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.references :listener,    foreign_key: true
      t.references :item,        foreign_key: true
      t.references :lottery,     foreign_key: true
      t.timestamps
    end
  end
end
