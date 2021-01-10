class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.references :user,    null: false
      t.string     :title,   null: false
      t.text       :details, null: false
      t.boolean    :line_msg_push, null: false
      t.timestamps
    end
  end
end
