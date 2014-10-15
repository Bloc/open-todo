module Api
  module V1
    class UsersController < ApiController

      def index
        render json: User.all
      end

      def show
        render json: User.find(params[:id])
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :success
        else
          render json: @user.errors, status: :errors
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password)
      end

    end
  end
end