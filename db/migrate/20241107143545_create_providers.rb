class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :service_type
      t.integer :experience
      t.decimal :hourly_rate
      t.text :bio
      t.float :rating
      t.string :location

      t.timestamps
    end
  end
end
