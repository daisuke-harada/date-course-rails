class Api::V1::GenresController < ApplicationController
  def show
    render status: :ok, json: {date_spots: DateSpot.includes(:date_spot_reviews).where(genre_id: params[:id]).map { |date_spot| DateSpotSerializer.new(date_spot) }}
  end
end
