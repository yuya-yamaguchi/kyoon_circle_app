class CreateUserReserves < ActiveRecord::Migration[6.0]
  def change
    create_table :user_reserves do |t|
      t.references :user, null: false
      t.references :studio, null: false
      t.date       :date, null: false
      t.integer    :start_time, null: false
      t.integer    :end_time, null: false
      t.integer    :payment_fee, default: 0
      t.timestamps
    end
  end
end
