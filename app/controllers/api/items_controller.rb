ActiveRecord::Base.include_root_in_json = true

class Api::ItemsController < ApiController


  def index
    return permission_denied_error unless conditions_met
    @user = User.find(params[:user_id])
    if @user.authenticate?(params[:password])
      render json: List.all
    else
      render json: List.all.not_private, each_serializer: ItemSerializer
    end
  end


  def destroy
    @item.destroy
    if @item.destroy
      render json: @list
    else
      render json: @item.errors, status: :errors
    end
  end

  def create

    @user = User.find(params[:user_id])
    @list = List.find(params[:list_id])

    if @item.save
      render json: @item
    else
      render json: @item.errors, :status => 500
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
