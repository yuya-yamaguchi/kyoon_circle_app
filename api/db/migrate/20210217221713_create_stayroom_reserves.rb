class CreateStayroomReserves < ActiveRecord::Migration[6.0]
  def change
    create_table :stayroom_reserves do |t|
      t.references :stayroom, null: false
      t.references :user, null: false
      t.integer    :fee, default: 0
      t.date       :checkin_date, null: false
      t.date       :checkout_date, null: false
      t.timestamps
    end
  end
end
