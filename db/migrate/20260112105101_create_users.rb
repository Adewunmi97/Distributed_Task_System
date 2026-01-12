class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, limit: 255
      t.string :encrypted_password, null: false, limit: 255
      t.string :role, null: false, default: 'member', limit: 50

      t.timestamps null: false
    end
    add_index :users, :email, unique: true, name: 'index_users_on_email'
    add_index :users, :role, name: 'index_users_on_role'
  end
end
