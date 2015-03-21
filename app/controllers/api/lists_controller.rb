module Api
  class Api::ListsController < Api::ApiController
    before_action :auth
    before_action :set_user
    before_action :set_list, only: [:show, :update, :destroy]

    def index
      @lists = List.all.select {|l| l if @user.can?(:view, l)}
      render json: @lists, each_serializer: ListSerializer
    end

    def show
      render json: @list if @user.can?(:view, @list)
    end

    def create
      @list = List.new(list_params[:name, :permissions])
      @list.user = @user

      if @list.save
        render json: @list, status: :created
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
      @user = User.find_by(username: params[:username])
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name, :permissions)
    end
  end
end
