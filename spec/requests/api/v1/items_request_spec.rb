require 'rails_helper'

describe "Items API" do 
  it "sends a list of items" do 

    merchant = create(:merchant).id 
    create_list(:item, 5, merchant_id: merchant)

    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:attributes)
      expect(item[:id]).to be_a(String)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "get a particular item based on id" do 

    id = create(:merchant).id 
    item = create(:item, merchant_id: id)

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(item).to have_key(:id)
  end
end
