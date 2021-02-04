class CreateSessionMusics < ActiveRecord::Migration[6.0]
  def change
    create_table :session_musics do |t|
      t.references :event, null: false
      t.references :user, null: false
      t.string     :title,  null: false
      t.string     :artist, null: false
      t.integer    :status, default: 0
      t.timestamps
    end
  end
end
