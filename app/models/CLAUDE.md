# app/models/ 実装方針

- アソシエーション・バリデーション・スコープを定義する
- ビジネスロジックが複数モデルにまたがる場合は `concerns/` に切り出す
- `ActiveHash` を使う場合（`genre.rb`, `prefecture.rb` など）は `include ActiveHash::Associations` を使う

## 検索（ransack）

- `ransackable_attributes` と `ransackable_associations` を必ず定義する（セキュリティ上必須）

```ruby
def self.ransackable_attributes(auth_object = nil)
  ["name", "prefecture_id", "genre_id", ...]
end

def self.ransackable_associations(auth_object = nil)
  ["date_spot_reviews", ...]
end
```

## 画像アップロード

- `CarrierWave` + `fog-aws`（S3）を使用する
- `mount_uploader :image, ImageUploader` をモデルに追加する
