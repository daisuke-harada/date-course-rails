# app/models/concerns/ 実装方針

- モデル間で共有するロジックを Concern として切り出す
- 例: JWT エンコード/デコード、画像 URL 生成ヘルパー、検索スコープ
- **`app/services/` は使わない**。サービスクラスに相当するロジックはここに置く

## 例: JWT（json_web_token.rb）

```ruby
# app/models/concerns/json_web_token.rb
module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    raise e
  end
end
```
