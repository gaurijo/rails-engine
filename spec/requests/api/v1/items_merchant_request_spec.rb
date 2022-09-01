require 'rails_helper'

RSpec.describe "Items Merchant API" do 
  it "gets a particular merchant based on the item id" do 
    merchant = create(:merchant).id 
    merchant2 = create(:merchant).id 
    id = create(:item, merchant_id: merchant).id

    get "/api/v1/items/#{id}/merchant"

    item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(item_merchant).to have_key(:attributes)
    expect(item_merchant[:id]).to be_a(String)
    expect(item_merchant[:type]).to eq("merchant")
    expect(item_merchant[:attributes][:name]).to be_a(String)
    expect(item_merchant[:id]).to_not eq(merchant2)
  end

  it "renders an error if a item is not found" do  

    merchant = create(:merchant).id 
    merchant2 = create(:merchant).id 
    id = create(:item, merchant_id: merchant).id

    get "/api/v1/items/5555/merchant"

    # item_merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry 
    expect(response.status).to eq(404)
  end
end