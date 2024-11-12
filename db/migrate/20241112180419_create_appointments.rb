class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.datetime :appointment_time
      t.integer :status

      t.timestamps
    end
  end
end
