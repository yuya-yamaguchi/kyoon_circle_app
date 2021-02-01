class CreateUserInstruments < ActiveRecord::Migration[6.0]
  def change
    create_table :user_instruments do |t|
      t.references :user,       null: false
      t.references :instrument, null: false
      t.timestamps
    end
  end
end
