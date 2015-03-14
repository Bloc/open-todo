module Api
  class Api::UsersController < Api::ApiController
    def index
      conditions_met?
      users = User.all
      render json: users, each_serializer: UserSerializer
    end

    def create
      conditions_met?
      @user = User.new(user_params)

      if @user.save
        render json: @user
      else
        error(422, @user.errors.full_messages.join(', '))
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def conditions_met?
      return permission_denied_error unless true
    end
  end
end
