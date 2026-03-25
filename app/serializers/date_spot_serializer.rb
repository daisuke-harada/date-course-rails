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
class DateSpotSerializer < ActiveModel::Serializer
  has_many :date_spot_reviews
  has_many :courses

  attributes :id, :name, :image, :closing_time, :opening_time, :created_at, :updated_at

  attribute :average_rate do
    object.average_rate_calculation
  end

  attribute :genre_id do
    object.genre_id
  end
end
