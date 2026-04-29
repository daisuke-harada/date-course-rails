class Api::V1::HomesController < ApplicationController
  def top
    render status: :ok, json: {
      areas: Area.all.map { |a| {id: a.id, name: a.name} },
      main_prefectures: Prefecture.majors.map { |p| {id: p.id, name: p.name} },
      main_genres: Genre.majors.map { |g| {id: g.id, name: g.name} },
      genres: Genre.all.map { |g| {id: g.id, name: g.name} },
      date_spots: DateSpot.includes(:date_spot_reviews).all.map { |date_spot| DateSpotSerializer.new(date_spot).serializable_hash }
    }
  end
end
