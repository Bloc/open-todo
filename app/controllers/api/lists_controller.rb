ActiveRecord::Base.include_root_in_json = true

class Api::ListsController < ApiController
  before_action :check_credentials, except: [:index]

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
      render json: @list
    else
      render json: @list.errors, status: :errors
    end
  end

  def update
    @list=List.find(params[:id])
    if @list.update_attributes(list_params)
      render json: @list
    else
      render json: @list.errors, status: :errors
    end
  end

  def create
    if !List.find_by_name(list_params[:name]).nil?
      render text: "false", :status => 500 and return
    end

    @list = @user.lists.build(list_params)

    if @list.save
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
