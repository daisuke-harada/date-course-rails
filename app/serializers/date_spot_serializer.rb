class DateSpotSerializer < ActiveModel::Serializer
  attributes :id, :name, :genre_id, :opening_time, :closing_time,
             :created_at, :updated_at,
             :city_name, :latitude, :longitude

  attribute :image do
    { url: object.image.url }
  end

  attribute :prefecture_name do
    object.prefecture_name
  end

  attribute :genre_name do
    object.genre.name
  end

  attribute :review_total_number do
    object.date_spot_reviews.size
  end

  attribute :average_rate do
    object.average_rate_calculation
  end
end
