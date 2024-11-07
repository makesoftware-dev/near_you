class AddNameToUserAndProvider < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :providers, :name, :string
  end
end
