class Api::V1::MerchantController < ApplicationController 
  def find
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").first
    if merchant.nil? 
      render json: { data: {message: "No merchants found"}}
    else
      render json: MerchantSerializer.new(merchant)
    end 
  end
end