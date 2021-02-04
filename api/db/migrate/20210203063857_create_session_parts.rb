class CreateSessionParts < ActiveRecord::Migration[6.0]
  def change
    create_table :session_parts do |t|
      t.references :session_music, null: false
      t.references :part_category, null: false
      t.integer    :status, default: 0
      t.timestamps
    end
  end
end
