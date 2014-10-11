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
        @resource = User.new(user_params)

        if @resource.save
          render :show, status: :success
        else
          render json: @resource.errors, status: :errors
        end
      end

      private

      def user_params
        params.permit(:username, :password)
      end

    end
  end
end