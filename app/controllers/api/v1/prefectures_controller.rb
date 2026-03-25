class Api::V1::PrefecturesController < ApplicationController
  def show
    address_and_date_spots = DateSpot.includes(:date_spot_reviews).where(prefecture_id: params[:id]).map do |date_spot|
      AddressSerializer.new(date_spot).serializable_hash
    end

    render status: :ok, json: address_and_date_spots
  end
end
