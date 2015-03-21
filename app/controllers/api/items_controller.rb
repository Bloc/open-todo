module Api
  class Api::ItemsController < Api::ApiController
    before_action :set_item, only: [:show, :destroy]
    before_action :set_list

    def index
      @items = @list.items
      render json: @items, each_serializer: ItemsSerializer
    end

    def show
      render json: @item
    end

    def create
      if @list.add(item_params[:description])
        render json: @item, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @item.mark_complete
      head :no_content
    end

    private

    def set_item
      @item = Item.find(params[:id])
    end

    def set_list
      @list = @item ? @item.list : List.find(params[:list_id])
    end

    def item_params
      params.require(:item).permit(:description, :completed)
    end
  end
end
