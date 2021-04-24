class CreateMessagerooms < ActiveRecord::Migration[6.0]
  def change
    create_table :messagerooms do |t|

      t.timestamps
    end
  end
end
