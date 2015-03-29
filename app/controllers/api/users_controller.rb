class Api::UserController < Api::ApiController
respond_to :json

  def index
    render json: @user.as_json(only: [:id, :username])
  end

  def create
    user = User.new(user_params)
    if user.save
      render status: 200, json {
        message: "Welcome to ToDo Api.",
        user: user
        }.to_json
    else
      render status: 422, json {
        message: "There was an error.",
        errors: list.errors
      }.to_json
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render status: 200, json: {
      message: "Successfully deleted User.",
      root: root
    }.to_json
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end


end
