class DropTableUserReserves < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_reserves
  end
end
