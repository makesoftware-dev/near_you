class AddCalendlyUrlToProviders < ActiveRecord::Migration[7.1]
  def change
    add_column :providers, :calendly_url, :string
  end
end
