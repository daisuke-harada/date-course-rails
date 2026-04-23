# app/controllers/api/v1/ 実装方針

- 認証・パラメータ受け取り・レスポンス返却のみを担当する
- ビジネスロジックやバリデーションは持たない
- 保存・更新が絡むアクションでは Form Object を使用する
- `before_action :authenticate_user!` で認証が必要なアクションを保護する
- `strong parameters` は `private` メソッドに切り出す

```ruby
# ✅ Good
def create
  form = DateSpotForm.new(date_spot_params)
  date_spot = form.save
  if date_spot
    render status: :created, json: { date_spot_id: date_spot.id }
  else
    render status: :unprocessable_entity, json: ErrorSerializer.new(form).as_json
  end
end

# ❌ Bad: コントローラーにバリデーションロジックを持たせない
def create
  if params[:name].blank?
    render status: :unprocessable_entity, json: { error_messages: ["名前を入力してください"] }
    return
  end
  ...
end
```

## strong parameters

- `params.require(:key).permit(...)` または `params.permit(...)` を使う
- `private` メソッドとして `xxx_params` に切り出す

```ruby
private

def date_spot_params
  params.permit(:name, :genre_id, :opening_time, :closing_time, :image, :prefecture_id, :city_name)
end
```
