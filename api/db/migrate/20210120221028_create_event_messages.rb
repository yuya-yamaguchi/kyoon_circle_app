class CreateEventMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :event_messages do |t|
      t.references :user, null: false
      t.references :event, null: false
      t.text       :text, null: false
      t.timestamps
    end
  end
end
