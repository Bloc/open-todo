class Api::UsersController < ApiController
before_action :authenticated?


  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
