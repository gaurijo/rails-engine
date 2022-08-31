class Api::V1::MerchantController < ApplicationController 
  def find
    # merchant = Merchant.find_by([:name])
    # merchant = Merchant.where("name = ?", params[:name])
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").first
    if merchant.nil? 
      render json: { data: {message: "No merchants found"}}
    else
      render json: MerchantSerializer.new(merchant)
    end
    # require 'pry'; binding.pry 
  end
end