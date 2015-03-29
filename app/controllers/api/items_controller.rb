class Api::ItemsController < Api::ApiController

  before_filter :find_list

  def create
    item = @list.items.new(item_params)
    if item.save
      render status: 200, json {
        message: "Successfully created Item.",
        list: @list,
        item: item
      }.to_json
    else
      render status: 422, json {
        message: "Item creation failed.",
        errors: item.errors
      }.to_json
    end

    def update
      item = @list.item.find(params[:id])
      if item.update(item_params)
        render status: 200, json {
          message: "Successfully updated item.",
          list: @list,
          item: item
        }.to_json
      else
        render status: 422, json {
          message: "Update Item failed.",
          errors: item.errors
        }.to_json
      end

    end

    def destroy
      item = @list.item.find(params[:id])
      item.destroy
      render status: 200, json {
        message: "Item deleted.",
        list: @list
        item: @item
      }.to_json
    end

    private

    def item_params
      params.require("item").permit("description")
    end

    def find_list
      @list = current_user.lists.find(params[:list_id])
    end
  end