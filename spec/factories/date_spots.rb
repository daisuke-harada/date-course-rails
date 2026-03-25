# == Schema Information
#
# Table name: date_spots
#
#  id            :bigint           not null, primary key
#  city_name     :string           not null
#  closing_time  :datetime
#  image         :string
#  latitude      :float
#  longitude     :float
#  name          :string           not null
#  opening_time  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  genre_id      :integer
#  prefecture_id :integer
#
# Indexes
#
#  index_date_spots_on_genre_id_and_created_at       (genre_id,created_at)
#  index_date_spots_on_prefecture_id_and_created_at  (prefecture_id,created_at)
#
FactoryBot.define do
  factory :date_spot do
    id { 1 }
    name { "キャナルシティ博多" }
    genre_id { Genre.find_by(id: 1).id }
    opening_time { "2000-01-01 08:00:00 UTC" }
    closing_time { "2000-01-01 23:00:00 UTC" }
    prefecture_id { Prefecture.find_by(id: 40).id }
    city_name { "福岡市博多区住吉1丁目2" }
  end

  factory :other_spot, class: DateSpot do
    id { 2 }
    name { "つなぐダイニング ZINO 天神店" }
    genre_id { Genre.find_by(id: 8).id }
    opening_time { "2000-01-01 08:00:00 UTC" }
    closing_time { "2000-01-01 23:00:00 UTC" }
    prefecture_id { Prefecture.find_by(id: 40).id }
    city_name { "福岡市中央区大名1-11-22-1" }
  end
end
