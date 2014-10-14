module AuthHelpers
  def authWithToken (access_token)
    request.headers['ACCESS-TOKEN'] = "#{access_token}"
  end

  def clearToken
    request.headers['ACCESS-TOKEN'] = nil
  end
end