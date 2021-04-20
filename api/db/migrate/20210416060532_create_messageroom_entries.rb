class CreateMessageroomEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :messageroom_entries do |t|
      t.references :messageroom, null: false
      t.references :user,        null: false
      t.timestamps
    end
  end
end
