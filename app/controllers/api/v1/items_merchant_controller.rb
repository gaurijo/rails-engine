class Api::V1::ItemsMerchantController < ApplicationController 
  def index
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    else
      render status: 404
    end
  end
end