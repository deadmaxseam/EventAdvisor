class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :event_id

      t.timestamps
    end
  end
end
