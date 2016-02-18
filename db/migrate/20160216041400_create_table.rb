class CreateTable < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :mytyping_id, null: false
      t.string :name, null: false
      t.timestamps null: false
      t.index :mytyping_id, :unique => true
    end

    create_table :rankings do |t|
      t.integer :game_id, null: false
      t.integer :rank, null: false
      t.datetime :scraped_at, null: false
      t.string :name, null: false
      t.integer :score, null: false
      t.string :title, null: false
      t.float :speed, null: false
      t.float :correctly, null: false
      t.float :time, null: false
      t.integer :types, null: false
      t.integer :failures, null: false
      t.integer :questions, null: false
      t.date :date, null: false
      t.timestamps null: false
      t.index [:game_id, :rank, :scraped_at], :unique => true
    end
  end
end
