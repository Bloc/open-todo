class Api::ItemsController< ApiController
before_action :authenticated?

  def create
    list = List.find(params[:list_id])
    item = list.items.new(items_params)

    if item.save
      render json: item
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def items_params
    params.require(:item).permit(:description)
  end
end
