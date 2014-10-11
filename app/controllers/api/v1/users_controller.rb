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
        respond_with User.create(params[:username, :password])

        if get_resource.save
          render :show, status: :created
        else
          render json: get_resource.errors, status: :unprocessable_entity
        end
      end
    end
  end
end