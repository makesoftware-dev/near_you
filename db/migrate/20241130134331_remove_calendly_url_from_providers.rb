class RemoveCalendlyUrlFromProviders < ActiveRecord::Migration[7.1]
  def change
    remove_column :providers, :calendly_url
  end
end
