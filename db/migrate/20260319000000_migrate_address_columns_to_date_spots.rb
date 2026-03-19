class MigrateAddressColumnsToDateSpots < ActiveRecord::Migration[7.1]
  def up
    add_column :date_spots, :prefecture_id, :integer
    add_column :date_spots, :city_name, :string, null: false, default: ""
    add_column :date_spots, :latitude, :float
    add_column :date_spots, :longitude, :float

    execute <<-SQL
      UPDATE date_spots
      SET prefecture_id = addresses.prefecture_id,
          city_name = addresses.city_name,
          latitude = addresses.latitude,
          longitude = addresses.longitude
      FROM addresses
      WHERE addresses.date_spot_id = date_spots.id
    SQL

    change_column_default :date_spots, :city_name, nil

    add_index :date_spots, [:prefecture_id, :created_at], name: "index_date_spots_on_prefecture_id_and_created_at"

    drop_table :addresses
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
