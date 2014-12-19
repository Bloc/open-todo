ActiveRecord::Base.include_root_in_json = true

class Api::ItemsController < ApiController
  before_action :check_credentials

  def index
    return permission_denied_error unless conditions_met
    @user = User.find(params[:user_id])
    @list = @user.lists.find(params[:list_id])
    if @user.authenticate?(params[:password])
      render json: Item.all
    else
      render json: Item.all.not_private, each_serializer: ItemSerializer
    end
  end


  def destroy
    @user = User.find(params[:user_id])
    @list = @user.lists.find(params[:list_id])
    @item = @list.items.find(params[:id])
    @item.mark_complete
    if @item.destroy
      render json: @list
    else
      render json: @item.errors, status: :errors
    end
  end

  def create
    @list = @user.lists.find(params[:list_id])
    @item = @list.items.build(item_params)

    if (@item.completed == true)
      @item.destroy
    end

    if @item.save
      render json: @item
    else
      render json: @item.errors, :status => 500
    end


  end

  def update
    @list = @user.lists.find(params[:list_id])
    @item=Item.find(params[:id])
    if @item.update_attributes(item_params)
      render json: @item
    else
      render json: @item.errors, status: :errors
    end
  end

  private

  def conditions_met
    true # We're not calling this an InsecureUserSerializer for nothing
  end

  def item_params
    params.require(:item).permit(:description, :list_id, :completed)
  end
end
