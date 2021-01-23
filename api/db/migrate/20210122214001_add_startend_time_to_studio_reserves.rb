class AddStartendTimeToStudioReserves < ActiveRecord::Migration[6.0]
  def change
    add_column :studio_reserves, :start_time, :time, null: false
    add_column :studio_reserves, :end_time, :time, null: false
    add_column :studio_reserves, :fee, :integer, default: 0
  end
end
