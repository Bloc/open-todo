module Api
  module V1
    class ListsController < ApiController
      before_action :set_user, except: [:index, :show]
      before_action :set_list, only: [:show, :edit, :update, :destroy]

      def index
        if params[:user_id] == nil
          render json: List.all.not_private
        else
          set_user
          if @user.id == @authorized_user
            render json: @user.lists.owner(@user)
          elsif @user.id != @authorized_user
            render json: @user.lists.not_private
          else
            render nothing: true, status: :bad_request
          end
        end
      end

      def show
        if (@list.permissions == "open") || (@list.user_id == @authorized_user)
          render json: @list
        else
          render json: @list.errors, status: :error
        end
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
        if @list.user_id == @authorized_user
          @list.update(list_params) 
          render nothing: true
        else
          render nothing: true, status: :unauthorized
        end
      end

      def destroy
        if @list.user_id == @authorized_user
          @list.destroy
          render nothing: true
        else
          render nothing: true, status: :unauthorized
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