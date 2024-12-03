class AddSessionDurationToAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_column :availabilities, :session_duration, :integer, default: 60, null: false
  end
end
