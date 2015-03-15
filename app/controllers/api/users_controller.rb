module Api
  class Api::UsersController < Api::ApiController
    # before_action :logged_in?, except: [:create]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all
      render json: @users, each_serializer: UserSerializer
    end

    def show
      render json: @user
    end

    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      session[:user_id] = nil
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
