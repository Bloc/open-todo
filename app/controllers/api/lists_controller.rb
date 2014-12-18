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
    @user = User.find(params[:user_id])
    @list=@user.lists.build(list_params)
    perm = @list.permissions
    puts perm
    unless (perm == "private") || (perm == "viewable")  || (perm == "open")
      render text: "Permissions not supported.  Permissions allowed are open, viewable, or private", :status => 500 and return
    end

    unless @user.can?(:edit, @list)
      render text: "no permission to edit", :status => 500 and return
    end
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
    perm = @list.permissions
    unless (perm == "private") || (perm == "viewable")  || (perm == "open")
      render text: "Permissions not supported.  Permissions allowed are open, viewable, or private", :status => 500 and return
    end
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
