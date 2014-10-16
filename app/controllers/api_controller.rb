include ActionController::HttpAuthentication::Token::ControllerMethods
include ActionController::MimeResponds

class ApiController < ApplicationController
before_filter :restrict_access

private

  def restrict_access
    access_token = request.headers['X-ACCESS-TOKEN']
    @authorized_user = ApiKey.where(access_token: access_token).first.user_id if access_token
  
    unless @authorized_user
        head status: :unauthorized
      return false
    end
  end
end