class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :messageroom, null: false
      t.references :user,        null: false
      t.text       :text,        null: false
      t.timestamps
    end
  end
end
