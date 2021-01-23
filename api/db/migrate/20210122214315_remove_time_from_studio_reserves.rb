class RemoveTimeFromStudioReserves < ActiveRecord::Migration[6.0]
  def change
    remove_column :studio_reserves, :time, :integer
  end
end
