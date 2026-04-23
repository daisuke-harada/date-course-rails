## プロジェクト概要

Ruby on Rails 製のデートコース提案 REST API。Rails 7.1 + PostgreSQL + JWT 認証構成。
`active_model_serializers` でレスポンスを整形し、Form Object パターンでバリデーションと保存ロジックを分離する。

## 開発プロセス（Step-by-Step）

- **分割統治**: 一度に巨大な機能を実装せず、動作可能な最小単位（1機能、1アクション）で提案すること。
- **合意形成不要**: 実装を始める前の承認は必要ないです
- **インクリメンタル**: 各ステップが完了するたびに、テストが通る状態を維持すること。
- **TDD**: 実装コードを書く前にテストを先に書く（Red → Green → Refactor）。テストなしの実装 PR はマージ禁止。
- **サービスクラス禁止**: `app/services/` は使わない。共通ロジックは `app/models/concerns/` または `app/controllers/concerns/` に Concern として切り出すこと。
- **動作保証**: 全タスクが完了したら `bundle exec rspec` を1回実行し、テストエラーがゼロになるまで修正を続けること。テストが通らない状態で作業を終了しない。

## ディレクトリごとの実装方針

各ディレクトリに配置した `CLAUDE.md` を参照すること。

| ディレクトリ | CLAUDE.md |
|---|---|
| `app/controllers/api/v1/` | [app/controllers/api/v1/CLAUDE.md](app/controllers/api/v1/CLAUDE.md) |
| `app/controllers/concerns/` | [app/controllers/concerns/CLAUDE.md](app/controllers/concerns/CLAUDE.md) |
| `app/forms/` | [app/forms/CLAUDE.md](app/forms/CLAUDE.md) |
| `app/models/` | [app/models/CLAUDE.md](app/models/CLAUDE.md) |
| `app/models/concerns/` | [app/models/concerns/CLAUDE.md](app/models/concerns/CLAUDE.md) |
| `app/serializers/` | [app/serializers/CLAUDE.md](app/serializers/CLAUDE.md) |
| `spec/` | [spec/CLAUDE.md](spec/CLAUDE.md) |

## コーディングルール

### 認証
- JWT トークンは `Authorization: Bearer <token>` ヘッダーで受け取る
- `authenticate_user!` を `before_action` で使用する
- JWT のエンコード/デコードロジックは `app/models/concerns/json_web_token.rb` の `JsonWebToken` モジュールに定義する（`app/services/` は使用しない）

### ジオコーダー
- `geocoder` Gem を使って住所から緯度・経度を取得する
- `config/initializers/geocoder.rb` に設定を記述する

## 開発コマンド

DB ホストが `db`（Docker サービス名）のため、**Rails・RSpec のコマンドは必ず `docker compose exec api` 経由で実行すること**。ローカルターミナルから直接実行すると DB に接続できずエラーになる。

```sh
docker compose up -d                                        # コンテナ起動
docker compose exec api bundle exec rails db:create         # DB 作成
docker compose exec api bundle exec rails db:migrate        # マイグレーション実行
docker compose exec api bundle exec rails db:seed           # シードデータ投入
docker compose exec api bundle exec rspec                   # テスト実行（全体）
docker compose exec api bundle exec rspec spec/requests/    # リクエストスペックのみ
docker compose exec api bundle exec rspec spec/models/      # モデルスペックのみ
docker compose exec api bundle exec rails routes            # ルーティング確認
docker compose exec api bundle exec standardrb --fix        # Lint 自動修正
docker compose exec api bundle exec annotate                # スキーマ情報コメント追記
```

## TDD（テスト駆動開発）

このプロジェクトでは TDD（テスト駆動開発）を採用する。必ず以下のサイクルで開発を進めること。
テスト規約の詳細は [spec/CLAUDE.md](spec/CLAUDE.md) を参照すること。

### Red → Green → Refactor サイクル

1. **Red**: 失敗するテストを先に書く（実装コードはまだ書かない）
2. **Green**: テストが通る最小限の実装を行う
3. **Refactor**: 動作を維持しながらコードを整理・改善する

### 実装順序

新しい API を実装する際は、必ず以下の順序で進める：

| ステップ | 対象 | 内容 |
|---|---|---|
| 1 | モデルスペック | バリデーション・アソシエーションのテストを先に記述 |
| 2 | モデル実装 | テストが通るようにモデルを実装 |
| 3 | リクエストスペック | 各アクションの正常系・異常系を先に記述 |
| 4 | コントローラー実装 | テストが通るようにコントローラーを実装 |

### PR マージ条件

- モデルスペック・リクエストスペックが両方存在すること
- `bundle exec rspec` がすべて通ること
- テストなしの実装 PR はマージ禁止
