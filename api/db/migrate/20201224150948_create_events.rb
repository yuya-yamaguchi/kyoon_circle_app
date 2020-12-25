class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :user, null: false
      t.string     :title, null: false
      t.text       :details, null: false
      t.string     :place
      t.string     :fee
      t.integer    :max_entry, default: 0
      t.datetime   :start_datetime
      t.datetime   :end_datetime
      t.integer    :event_type, default: 0
      t.timestamps
    end
  end
end
