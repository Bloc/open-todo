module Api
  class Api::SessionsController < Api::ApiController
    def create
      @user = User.find_by_username(params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      session[:user_id] = nil
      head :no_content
    end
  end
end
