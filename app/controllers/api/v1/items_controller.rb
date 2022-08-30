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
end