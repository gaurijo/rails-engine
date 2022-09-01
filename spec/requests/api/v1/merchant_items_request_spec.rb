require 'rails_helper'

  describe "MerchantItems API" do 
    it "gets a merchant's items" do 

    id = create(:merchant).id 
    merchant_items = create_list(:item, 3, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(merchant_items.count).to eq(3)

    merchant_items.each do |merchant_item|
      expect(merchant_item).to have_key(:id)
      expect(merchant_item[:id]).to be_a(String)
    end
  end
end