class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :role_name

      t.timestamps
    end
  end
end
