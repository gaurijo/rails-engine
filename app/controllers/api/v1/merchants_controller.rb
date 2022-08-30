class Api::V1::MerchantsController < ApplicationController 
  def index 
    merchants = Merchant.all 
    render json: MerchantSerializer.new(merchants) #render this way when using serializer gem

    #if using handrolling it would be:
    #render json: MerchantSerializer.format_merchants(Merchant.all)
  end

  def show 
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end