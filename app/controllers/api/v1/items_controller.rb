module Api
  module V1
    class ItemsController < ApplicationController
      before_action :set_item, only: [:update, :destroy]
      before_action :set_list

      def create
        if (@list.permissions = "open") || (@list.user_id == @authorized_user)
          @list.add(item_params[:description])
          render nothing: true
        else
          render nothing: true, status: :unprocessable_entity
        end
      end

      def destroy
        if (@list.permissions = "open") || (@list.user_id == @authorized_user)
          @item.mark_complete
          render nothing: true
        else
          render nothing: true, status: :errors
        end
      end

      private

      def set_item
        @item = Item.find(params[:id])
      end

      def set_list
        @list = @item ? @item.list : List.find(params[:list_id])
      end

      def item_params
        params.require(:item).permit(:description, :list_id, :completed)
      end
    end
  end
end
