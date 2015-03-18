module Api
  class Api::ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token

    respond_to :json

    private

    def auth
      authenticate_or_request_with_http_basic do |u, p|
        user = User.find_by(username: u)
        user.try(:authenticate, p)
      end
    end

    def permission_denied
      error(403, 'Permission Denied!') unless true
    end

    def error(status, message = 'Something went wrong')
      response = {
        response_type: "ERROR",
        message: message
      }

      render json: response.to_json, status: status
    end
  end
end
