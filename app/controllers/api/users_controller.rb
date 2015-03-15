module Api
  class Api::UsersController < Api::ApiController
    before_action :conditions_met?
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all
      render json: @users, each_serializer: UserSerializer
    end

    # def show
    #   render json: @user
    # end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # def update
    #   if @user.update(user_params)
    #     head :no_content
    #   else
    #     render json: @user.errors, status: :unprocessable_entity
    #   end
    # end

    # def destroy
    #   @user.destroy
    #   head :no_content
    # end

    private

    def conditions_met?
      permission_denied_error unless true
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password)
    end
  end
end
