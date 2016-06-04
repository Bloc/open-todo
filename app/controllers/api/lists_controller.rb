class Api::ListsController< ApiController
 before_action :authenticated?

  def create
    user = User.find(params[:user_id])
    list = user.lists.new(lists_params)

    #needs completion
    if list.save
      render json: list
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

private

  def lists_params
    params.require(:list).permit(:name,:permissions)
  end
end
