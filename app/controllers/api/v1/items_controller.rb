class Api::V1::ItemsController < ApplicationController 
  def index
    items = Item.all 
    render json: ItemSerializer.new(items)
  end

  def show 
    item = Item.find(params[:id])
    # require 'pry'; binding.pry 
    render json: ItemSerializer.new(item)
  end
  
  def create 
    item = Item.create(item_params) 
    # require 'pry'; binding.pry 
    render json: ItemSerializer.new(item), status: :created
    # render json: ItemSerializer.new(item)
  end

  # def destroy 
  #   item = Item.destroy(item_params)
  # end

private 
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end