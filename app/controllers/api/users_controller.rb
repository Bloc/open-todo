class Api::UsersController < ApplicationController
  before_filter :set_response
  respond_to :json
  def index
    @users = User.all
    respond_with @users.each do |user|
      as_json(user)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :index
    else
      redirect_to :index
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