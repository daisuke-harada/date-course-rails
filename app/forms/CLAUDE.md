# app/forms/ 実装方針

- `ActiveModel::Model` を include して Form Object を定義する
- バリデーションと保存（または更新）ロジックをここに集約する
- `save` メソッドと `update` メソッドを実装する
- `ActiveRecord::Base.transaction` でトランザクション処理を行う

```ruby
class XxxForm
  include ActiveModel::Model

  attr_accessor :field1, :field2

  validates :field1, presence: true

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @record = Xxx.new(attributes)
      @record.save!
    end
    @record
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update(record)
    return false unless valid?
    ActiveRecord::Base.transaction do
      record.update!(attributes)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
```
