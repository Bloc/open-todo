class Api::ItemsController< ApiController
before_action :authenticated?

  def create
    list = Item.find(:item_id)
    item = list.item.new(:items_params)

    #needs completion
    if item.save
      render json: item
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

end
