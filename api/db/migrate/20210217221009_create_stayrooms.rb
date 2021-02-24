class CreateStayrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :stayrooms do |t|
      t.string  :name, null: false
      t.integer :fee, default: 0
      t.timestamps
    end
  end
end
