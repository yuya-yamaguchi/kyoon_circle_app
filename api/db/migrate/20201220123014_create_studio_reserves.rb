class CreateStudioReserves < ActiveRecord::Migration[6.0]
  def change
    create_table :studio_reserves do |t|
      t.references :studio, null: false
      t.references :user, null: false
      t.date       :date, null: false
      t.integer    :hour, default: 0
      t.integer    :minutes, default: 0
      t.integer    :reserve_type, default: 0
      t.timestamps
    end
  end
end
