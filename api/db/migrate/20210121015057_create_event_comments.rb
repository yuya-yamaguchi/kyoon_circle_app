class CreateEventComments < ActiveRecord::Migration[6.0]
  def change
    create_table :event_comments do |t|
      t.references :event, null: false
      t.references :user,  null: false
      t.text       :text,  null: false
      t.timestamps
    end
  end
end
