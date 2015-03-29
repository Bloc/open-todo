class Api::ListsController < Api::ApiController

  def index
    render json: List.all
  end

  def show
    list = current_user.lists.find(params[:id])
    render json: list.as_json(include:[:items])
  end

  def create
    list = current_user.lists.new(list_params)
    if list.save
      render status: 200, json: {
        message: "Successfully created List.",
        list: list
      }.to_json
    else
      render status: 422, json {
        errors: list.errors
      }.to_json
    end
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    render status: 200, json: {
        message: "Successfully updated List.",
        list: list
    }.to_json
    end
  end

  def update
    list = current_user.lists.find(params[:id])
    if list.update(list_params)
      render status: 200, json: {
        message: "Successfully deleted List.",
        list: list
      }.to_json
    else
    render status: 422, json {
        message: "List could not be updated.",
        list: list
      }.to_json
    end
  end

  private

  def list_params
    params.require("list").permit("name")

  end

end
