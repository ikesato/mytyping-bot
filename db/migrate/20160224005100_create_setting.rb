class CreateSetting < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :value
      t.timestamps null: false
      t.index :name, :unique => true
    end
  end
end
