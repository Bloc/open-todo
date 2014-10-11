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
      end
      
    end
  end
end