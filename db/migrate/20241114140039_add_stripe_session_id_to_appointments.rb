class AddStripeSessionIdToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :stripe_session_id, :string
  end
end
