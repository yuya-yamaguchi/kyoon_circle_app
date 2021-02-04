class CreateUserEntryParts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_entry_parts do |t|
      t.references :user, null: false
      t.references :session_part, null: false
      t.timestamps
    end
  end
end