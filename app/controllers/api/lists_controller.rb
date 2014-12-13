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
    else
      render json: @list.errors, status: :errors
    end
  end

  def create
    i=0
    @list = List.new(list_params)
    @user = User.find(params[:user_id])

    if @user.authenticate?(params[:password])
      i=0
    else
      i=1
    end

    @list.user_id = @user.id


    List.all.each do |b|
      if b.name == @list.name
        i=1
      else
      end
    end

    if (@list.save && i==0)
      render json: @list
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
