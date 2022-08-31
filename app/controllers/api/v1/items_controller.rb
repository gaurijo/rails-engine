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
  
  def update 
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy 
    item = Item.find(params[:id]).destroy
    # item = Item.destroy(params[:id])
  end

  def find_all 
    items = Item.where("name ILIKE ?", "%#{params[:name]}%").all
    if items.nil?
      render json: { data: {message: "No items found"}}
    else
      render json: ItemSerializer.new(items)
    end
  end

private 
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end