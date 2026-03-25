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
class DateSpot < ApplicationRecord
  mount_uploader :image, ImageUploader
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :genre
  belongs_to_active_hash :prefecture
  has_many :date_spot_reviews, dependent: :destroy
  has_many :during_spots, dependent: :destroy
  has_many :courses, through: :during_spots

  delegate :name, to: :prefecture, prefix: true

  geocoded_by :city_name
  after_validation :geocode, if: :city_name_changed?

  validates :name, presence: true
  validates :genre_id, presence: true
  validates :city_name, presence: true
  validates :prefecture_id, presence: true

  # ransackに必要な定義
  def self.ransackable_attributes(auth_object = nil)
    ["city_name", "closing_time", "created_at", "genre_id", "id", "image", "latitude", "longitude", "name", "opening_time", "prefecture_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["date_spot_reviews", "during_spots", "genre"]
  end

  # date_spot_reviewの評価の平均値を計算する
  def average_rate_calculation
    # レビューが空の場合は0を返す
    return 0 if date_spot_reviews.empty?

    # レビューの評価の合計を計算
    review_rate_total = date_spot_reviews.sum(&:rate)

    # 評価の合計が0の場合は0を返し、そうでなければ平均値を計算して返す
    (review_rate_total == 0) ? 0 : review_rate_total / date_spot_reviews.length.to_f
  end
end
