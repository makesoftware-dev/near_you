class AddCategoryToProvider < ActiveRecord::Migration[7.1]
  def change
    add_column :providers, :category, :string
  end
end
