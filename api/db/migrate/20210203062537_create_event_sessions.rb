class CreateEventSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :event_sessions do |t|
      t.references :event, null: false
      t.string     :max_musics, default: 0
      t.timestamps
    end
  end
end
