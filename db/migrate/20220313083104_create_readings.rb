class CreateReadings < ActiveRecord::Migration[6.1]
  def change
    create_table :readings do |t|
      t.integer :data, null: false
      t.datetime :recorded_at, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
