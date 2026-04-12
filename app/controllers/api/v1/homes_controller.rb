class Api::V1::HomesController < ApplicationController
  def top
    render status: :ok, json: {
      areas: Area.all,
      main_prefectures: Prefecture.majors,
      main_genres: Genre.majors,
      genres: Genre.all,
      date_spots: DateSpot.includes(:date_spot_reviews).all.map { |date_spot| DateSpotSerializer.new(date_spot).as_json }
    }
  end
end
