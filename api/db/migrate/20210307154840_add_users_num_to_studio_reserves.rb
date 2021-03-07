class AddUsersNumToStudioReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :studio_reserves, :users_num, :integer, default: 0
  end
end
