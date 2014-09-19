class Api::UsersController < ApplicationController
  before_filter :set_response
  respond_to :json
  def index
    @users = User.all
    respond_with @users.as_json(only: [:id, :username], root: true)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_with @user
    else
      render json: {error: 'There was a problem saving the user.'}
    end
  end

  private

  def user_params
      params.require(:user).permit(:username, :password)
  end

  def set_response
    request.format = :json
  end
end