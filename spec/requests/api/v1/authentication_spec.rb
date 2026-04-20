require "rails_helper"

# authenticate_user! ミドルウェアの動作を検証する
# before_action :authenticate_user! が適用されているエンドポイント (RelationshipsController) で確認する
RSpec.describe "Authentication middleware", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  describe "authenticate_user!" do
    context "Authorization ヘッダーがない場合" do
      it "401 を返す" do
        post "/api/v1/relationships", params: {
          "current_user_id" => user.id,
          "followed_user_id" => other_user.id
        }
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error_messages"]).to be_present
      end
    end

    context "不正なトークンの場合" do
      it "401 を返す" do
        post "/api/v1/relationships",
          params: {"current_user_id" => user.id, "followed_user_id" => other_user.id},
          headers: {"Authorization" => "Bearer invalid_token"}
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error_messages"]).to be_present
      end
    end

    context "期限切れトークンの場合" do
      it "401 を返す" do
        expired_token = JsonWebToken.encode({user_id: user.id}, 1.hour.ago)
        post "/api/v1/relationships",
          params: {"current_user_id" => user.id, "followed_user_id" => other_user.id},
          headers: {"Authorization" => "Bearer #{expired_token}"}
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)["error_messages"]).to include("トークンの有効期限が切れています。再度ログインしてください。")
      end
    end

    context "有効なトークンの場合" do
      it "認証が通り、201 を返す" do
        valid_token = JsonWebToken.encode(user_id: user.id)
        post "/api/v1/relationships",
          params: {"current_user_id" => user.id, "followed_user_id" => other_user.id},
          headers: {"Authorization" => "Bearer #{valid_token}"}
        expect(response.status).to eq(201)
      end
    end
  end
end
