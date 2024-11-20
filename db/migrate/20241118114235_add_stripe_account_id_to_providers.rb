class AddStripeAccountIdToProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :providers, :stripe_account_id, :string
  end
end
