module Api
  class Api::UsersController < Api::ApiController
    before_action :auth, only: [:update, :destroy]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all
      render json: @users, each_serializer: UserSerializer
    end

    def show
      render json: @user, serializer: UserSerializer
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
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
