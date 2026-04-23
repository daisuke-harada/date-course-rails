# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE)
#  email           :string           not null
#  gender          :string           not null
#  image           :string
#  name            :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name) UNIQUE
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :admin, :email, :gender, :image, :name, :followerIds, :followingIds

  attribute :courses do
    object.courses.map { |course| CourseSerializer.new(course) }
  end

  attribute :date_spot_reviews do
    object.date_spot_reviews.includes(:date_spot).map do |review|
      spot = review.date_spot
      {
        id: review.id,
        rate: review.rate,
        content: review.content,
        date_spot: {
          id: spot.id,
          name: spot.name,
          city_name: spot.city_name,
          latitude: spot.latitude,
          longitude: spot.longitude,
          opening_time: spot.opening_time,
          closing_time: spot.closing_time,
          genre_id: spot.genre_id,
          image: {url: spot.image.url}
        }
      }
    end
  end

  attribute :followerIds do
    object.followers.pluck(:id)
  end

  attribute :followingIds do
    object.followings.pluck(:id)
  end
end
