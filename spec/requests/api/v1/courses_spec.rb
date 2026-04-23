require "rails_helper"

RSpec.describe "Api::V1::Courses", type: :request do
  let(:user) { create(:user) }
  let(:date_spot) { create(:date_spot) }
  let(:other_spot) { create(:other_spot) }
  let(:course) { build(:course) }

  describe "POST /create" do
    context "認証済みユーザー" do
      it "入力された値が正しい場合はcourseを登録することができる" do
        post "/api/v1/courses", params: {
          course: {
            user_id: user.id,
            travel_mode: course.travel_mode,
            authority: course.authority,
            date_spots: [date_spot.id, other_spot.id]
          }
        }, headers: auth_headers(user)
        expect(response.status).to eq(201)
      end
    end

    context "未認証ユーザー" do
      it "401 を返す" do
        post "/api/v1/courses", params: {
          course: {
            user_id: user.id,
            travel_mode: course.travel_mode,
            authority: course.authority,
            date_spots: [date_spot.id, other_spot.id]
          }
        }
        expect(response.status).to eq(401)
      end
    end
  end
end
