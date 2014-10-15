module Api
  module V1
    class ListsController < ApiController
      before_action :set_user
      before_action :set_list, only: [:show, :edit, :update, :destroy]

      def index
        render json: @user.lists
      end

      def show
        render json: @list.items.completed
      end

      def create
        @list = List.new(list_params) 
        @list.user_id = @user.id 
        if @list.save
          render json: @list
        else
          render json: @list.errors, status: :unprocessable_entity
        end
      end

      def update
        if @list.update(list_params)
        else
          render json: @list.errors, status: :errors
        end
      end

      def destroy
        if @list.destroy
        else
          render status: :errors
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def set_list
        @list = List.find(params[:id])
      end

      def list_params
        params.require(:list).permit(:name, :permissions)
      end
    end
  end
end