module AuthHelpers
  def authWithToken(access_token)
    request.headers['X-ACCESS-TOKEN'] = "#{access_token}"
  end

  def clearToken
    request.headers['X-ACCESS-TOKEN'] = nil
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :controller
end