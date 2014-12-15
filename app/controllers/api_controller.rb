class ApiController < ApplicationController
  before_action :check_credentials

  def check_credentials

    @user = User.find(params[:user_id])

    unless @user.authenticate?(params[:password])
      render text: "bad username or password", :status => 401 and return
    end

  end

end
