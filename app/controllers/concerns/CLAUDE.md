# app/controllers/concerns/ 実装方針

- コントローラー間で共有する処理を Concern として切り出す
- 例: JWT デコード・認証ヘルパー、ページネーションヘルパー

```ruby
# app/controllers/concerns/authenticatable.rb
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[create update destroy]
  end

  private

  def authenticate_user!
    # JWT デコードと @current_user のセット
  end
end
```
