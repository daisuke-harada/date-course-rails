class ApplicationController < ActionController::API
  # 404: 存在しないレコードへのアクセス (.find が失敗した場合)
  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: :not_found, json: {error_messages: [e.message]}
  end

  # 422: save!/create!/update! などのバリデーション失敗
  rescue_from ActiveRecord::RecordInvalid do |e|
    render status: :unprocessable_entity, json: {error_messages: e.record.errors.full_messages}
  end

  # 422: DBのユニーク制約違反 (Railsバリデーションをすり抜けた場合)
  rescue_from ActiveRecord::RecordNotUnique do |e|
    render status: :unprocessable_entity, json: {error_messages: ["すでに登録されています"]}
  end

  # 400: params.require(:key) でキーが欠落している場合
  rescue_from ActionController::ParameterMissing do |e|
    render status: :bad_request, json: {error_messages: [e.message]}
  end

  # 500: 上記以外の予期しないサーバーエラー
  rescue_from StandardError do |e|
    render status: :internal_server_error, json: {error_messages: [e.message]}
  end
end
