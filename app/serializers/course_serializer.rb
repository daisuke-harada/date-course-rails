# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  authority   :string           not null
#  travel_mode :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_courses_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class CourseSerializer < ActiveModel::Serializer
  attributes :id, :authority, :travel_mode, :no_duplicate_prefecture_names

  attribute :user do
    {
      id: object.user.id,
      name: object.user.name,
      email: object.user.email,
      gender: object.user.gender,
      image: {
        url: object.user.image.url
      },
      admin: object.user.admin
    }
  end

  attribute :date_spots do
    object.date_spots.map do |date_spot|
      AddressSerializer.new(date_spot)
    end
  end

  attribute :no_duplicate_prefecture_names do
    prefecture_ids = object.date_spots.map { |date_spot| date_spot.prefecture_id }.uniq
    Prefecture.where(id: prefecture_ids).pluck(:name).uniq
  end
end
