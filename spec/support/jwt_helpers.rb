module JwtHelpers
  def jwt_token(user)
    JsonWebToken.encode(user_id: user.id)
  end

  def auth_headers(user)
    {"Authorization" => "Bearer #{jwt_token(user)}"}
  end
end

RSpec.configure do |config|
  config.include JwtHelpers, type: :request
end
