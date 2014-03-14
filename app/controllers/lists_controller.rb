class ListsController < ApplicationController
  before_action :set_user
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def show
    @items = @list.items.completed
  end

  def new
    @list = List.new
  end

  def edit
  end

  def index
    @lists = @user.lists
  end

  def create
    @list = List.new(list_params)
    @list.user_id = @user.id

    if @list.save
      redirect_to user_list_path(@user, @list), notice: 'List was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @list.update(list_params)
      redirect_to user_list_path(@user, @list), notice: 'List was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @list.destroy
    redirect_to @user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :user_id, :permissions)
  end
end
