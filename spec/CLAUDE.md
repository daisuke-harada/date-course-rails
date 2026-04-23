# spec/ テスト規約

## テストの種別と配置

| 種別 | 配置場所 | 用途 |
|---|---|---|
| モデルスペック | `spec/models/` | バリデーション・スコープ・メソッドのテスト |
| リクエストスペック | `spec/requests/api/v1/` | API エンドポイントの統合テスト |

## テスト形式

- `describe` → `context` → `it` の階層でテストを構造化する
- テスト名は**英語**で記述する（日本語禁止）

```ruby
# ✅ Good
RSpec.describe "Api::V1::DateSpots", type: :request do
  describe "GET /api/v1/date_spots" do
    context "when no search params" do
      it "returns all date spots with status 200" do
        get api_v1_date_spots_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

# ❌ Bad: 日本語のテスト名
it "デートスポット一覧を返すこと" do
```

## FactoryBot

- `spec/factories/` にファクトリを定義する
- テストデータは `create` / `build` で生成する

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    gender { "male" }
  end
end
```

## 認証が必要なエンドポイントのテスト

```ruby
let(:user) { create(:user) }
let(:token) { JsonWebToken.encode(user_id: user.id) }
let(:headers) { { "Authorization" => "Bearer #{token}" } }

it "returns 201" do
  post api_v1_date_spots_path, params: valid_params, headers: headers
  expect(response).to have_http_status(:created)
end
```
