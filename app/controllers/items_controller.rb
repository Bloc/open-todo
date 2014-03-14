class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]
  before_action :set_list

  def create
    
    if @list.add(item_params[:description])
      redirect_to user_list_path(@list.user, @list), notice: 'Item was successfully created.'
    else
      render action: 'new'
    end
  end

  def new
    @item = Item.new
  end

  def destroy
    @item.mark_complete
    redirect_to user_list_path(@list.user, @list)
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
