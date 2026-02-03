class CreateDateSpotReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :date_spot_reviews do |t|
      t.float :rate
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :date_spot, null: false, foreign_key: true

      t.timestamps
    end

    add_index :date_spot_reviews, [:user_id, :date_spot_id], unique: true
  end
end
