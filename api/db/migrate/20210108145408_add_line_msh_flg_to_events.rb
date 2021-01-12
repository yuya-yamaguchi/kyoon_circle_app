class AddLineMshFlgToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :line_msg_push, :boolean, default: false
  end
end
