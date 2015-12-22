class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|

      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      t.datetime :locked_at

      t.string :username, null: false
      t.string :realname
      t.integer :status
      t.integer :role
      t.string :phone_number
      t.jsonb :preferences, null: false, default: '{}'
      t.text :note
      t.belongs_to :op

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index  :users, :preferences, using: :gin
  end
end
