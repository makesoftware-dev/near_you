class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :day_of_week
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :available

      t.timestamps
    end
  end
end
