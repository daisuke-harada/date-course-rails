class AddressSerializer < ActiveModel::Serializer
  attributes :id, :city_name, :latitude, :longitude

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

  attribute :date_spot do
    DateSpotSerializer.new(object).attributes
  end
end
