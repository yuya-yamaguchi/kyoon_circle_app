class ChangeAdminFlgOfUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :admin_flg, :boolean
    add_column    :users, :admin_type, :integer, default: 0
  end
end
