class CreateUserEntryParts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_entry_parts do |t|
      t.references :user, null: false
      t.references :session_part, null: false
      t.references :event, null: false
      t.timestamps
    end

    add_index :user_entry_parts, %i[user_id session_part_id], unique: true
  end
end
