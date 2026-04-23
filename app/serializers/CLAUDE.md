# app/serializers/ 実装方針

- `ActiveModel::Serializer` を継承してレスポンス整形を担当する
- `attributes` でレスポンスに含めるフィールドを宣言する
- コントローラーでは `XxxSerializer.new(record).as_json` または `XxxSerializer.new(record).serializable_hash` を使う
- ネストした情報が必要な場合は `has_many` / `belongs_to` を使うか、カスタム `attribute` ブロックを定義する

## エラーレスポンス

- 全エラーのレスポンス形式: `{ "error_messages": ["メッセージ"] }`
- `ErrorSerializer` を使って Form Object やモデルのエラーを統一形式で返す
