class AddStripeDetailsToProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :providers, :stripe_status, :string
    add_column :providers, :charges_enabled, :boolean
    add_column :providers, :payouts_enabled, :boolean
    add_column :providers, :requirements_due, :jsonb
  end
end
