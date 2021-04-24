class AddReadFlgToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read_flg, :boolean, default: false
  end
end
