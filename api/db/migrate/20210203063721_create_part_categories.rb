class CreatePartCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :part_categories do |t|
      t.references :instrument, null: false
      t.string     :name, null: false
      t.timestamps
    end
  end
end
