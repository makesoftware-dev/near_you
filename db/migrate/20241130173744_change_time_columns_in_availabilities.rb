class ChangeTimeColumnsInAvailabilities < ActiveRecord::Migration[7.1]
  def change
    change_column :availabilities, :start_time, :time
    change_column :availabilities, :end_time, :time
  end
end
