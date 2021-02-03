class AddEventCategoryIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :event_category, foreign_key: true
  end
end
