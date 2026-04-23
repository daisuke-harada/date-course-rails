require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user) }

    it "ユーザーのログインに成功し JWT トークンが返る" do
      post "/api/v1/login", params: {sign_in_params: {name: user.name, password: user.password}}
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body["user"]["id"]).to eq(user.id)
      expect(body["user"]["name"]).to eq(user.name)
      expect(body["user"]["email"]).to eq(user.email)
      expect(body["user"]["gender"]).to eq(user.gender)
      expect(body["user"]["admin"]).to eq(user.admin)
      expect(body["token"]).to be_present
    end

    it "ユーザーのログインに失敗する" do
      post "/api/v1/login", params: {sign_in_params: {name: "daisuke", password: user.password}}
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)["error_messages"]).to eq(["認証に失敗しました。", "正しい名前・パスワードを入力し直すか、新規登録を行ってください。"])
    end
  end
end
