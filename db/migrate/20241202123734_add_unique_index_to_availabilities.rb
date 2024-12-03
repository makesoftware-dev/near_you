class AddUniqueIndexToAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_index :availabilities, [:provider_id, :day_of_week], unique: true, name: "index_provider_day_of_week"
  end
end
