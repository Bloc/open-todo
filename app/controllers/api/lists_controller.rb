ActiveRecord::Base.include_root_in_json = true

class Api::ListsController < ApiController


  def index
    return permission_denied_error unless conditions_met
    @user = User.find(params[:user_id])
    if @user.authenticate?(params[:password])
      render json: List.all
    else
      render json: List.all.not_private, each_serializer: ListSerializer
    end
  end


  def destroy
    @list.destroy
    if @list.destroy
      render json: @user
    elseist
      render json: @list.errors, status: :errors
    end
  end

  def create
    @list = List.new(list_params)
    @list.user_id = @user.id

    if @user.save
      render json: UserSerializer.new(@list).to_json
    else
      render json: @list.errors, :status => 500
    end

  end

  private

  def conditions_met
    true # We're not calling this an InsecureUserSerializer for nothing
  end

  def list_params
    params.require(:list).permit(:name, :user_id, :permissions)
  end
end
