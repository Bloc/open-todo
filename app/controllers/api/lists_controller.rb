module Api
  class Api::ListsController < Api::ApiController
    before_action :set_user
    before_action :set_list, only: [:show, :update, :destroy]

    def index
      @lists = @user.lists
      render json: @lists, each_serializer: ListSerializer
    end

    def show
      render json: @list
    end

    def create
      @list = List.new(list_params[:name, :permissions])
      @list.user_id = @user.id

      if @list.save
        render json: @list, status: :created, location: @list
      else
        render json: @list.errors, status: :unprocessable_entity
      end
    end

    def update
      if @list.update(list_params)
        head :no_content
      else
        render json: @list.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @list.destroy
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name, :permissions, :user_id)
    end
  end
end
