class ApiController < ApplicationController
  before_action :check_credentials
  skip_before_action :verify_authenticity_token

  respond_to :json

  def check_credentials

    @user = User.find(params[:user_id])


    unless @user.authenticate?(params[:password])
      render text: "bad username or password", :status => 401 and return
    end

  end

  private

  # Error responses and before_action blocking work differently with Javascript requests.
  # Rather than using before_actions to authenticate actions, we suggest using
  # "guard clauses" like `permission_denied_error unless condition`
  def permission_denied_error
    error(403, 'Permission Denied!')
  end

  def error(status, message = 'Something went wrong')
    response = {
      response_type: "ERROR",
      message: message
    }

    render json: response.to_json, status: status
  end

end
