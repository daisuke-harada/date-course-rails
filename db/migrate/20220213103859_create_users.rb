class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :gender, null: false
      t.string :image
      t.boolean :admin, default: false
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :name, unique: true
  end
end
