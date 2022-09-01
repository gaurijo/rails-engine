class Api::V1::ItemsController < ApplicationController 
  def index
    items = Item.all 
    render json: ItemSerializer.new(items)
  end

  def show 
    item = Item.find(params[:id])
    if item.nil?
      render json: { data: {message: "No items found"}}
    else
      render json: ItemSerializer.new(item)
    end
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
  end

  # def find_price 
  #   items = Item.where("unit_price = ?", params[:unit_price]).all
  #   if items.nil?
  #     render json: {data: {message: "No items found"}}
  #   else
  #     render json: ItemSerializer.new(items)
  #   end
  # end

  def find_all 
    items = Item.where("name ILIKE ?", "%#{params[:name]}%").all
    render json: ItemSerializer.new(items)
  end

private 
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end