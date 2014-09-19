
class Api::UsersController < ApplicationController
  def index
    @users = User.all
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
end