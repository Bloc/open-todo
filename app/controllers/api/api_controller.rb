module Api
  class Api::ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token

    respond_to :json

    private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      error(403, "Must be logged in. Go to /login or /signup.") if current_user.nil?
    end

    def protected?
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
