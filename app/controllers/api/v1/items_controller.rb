class Api::V1::ItemsController < ApplicationController 
  def index
    items = Item.all 
    render json: ItemSerializer.new(items)
  end

  def show 
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end
  
  def create 
    item = Item.create(item_params) 
    render json: ItemSerializer.new(item), status: :created
  end

  def destroy 
    item = Item.find(params[:id]).destroy
    # item = Item.destroy(params[:id])
  end

private 
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end