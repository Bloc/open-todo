module Api
  module V1
    class ListsController < ApiController

      def index
        render json: @user.lists
      end

      def show
        render json: @list.items
      end

      def create
        list = List.new(list_params)

        if list.save
          render json: list, status: :success
        else
          render json: list.errors, status: :unprocessable_entity
        end
      end

      private

      def list_params
        params.require(:list).permit(:name, :permissions)
      end
    end
  end
end