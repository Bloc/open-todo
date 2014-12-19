ActiveRecord::Base.include_root_in_json = true

class Api::UsersController < ApiController
  def index
    return permission_denied_error unless conditions_met

    render json: User.all, each_serializer: InsecureUserSerializer
  end


  def destroy
    @user = User.find(params(:id))
    if @user.destroy
      render json: @user
    else
      render json: @user.errors, status: :errors
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).to_json
    else
      render json: @user.errors, :status => 500
    end

  end

  private

  def conditions_met
    true # We're not calling this an InsecureUserSerializer for nothing
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
