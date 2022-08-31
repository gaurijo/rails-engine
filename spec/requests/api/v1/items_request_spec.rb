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

    merchant_id = create(:merchant).id 
    #item HAS to have a merchant id associated so need merchant id first 
    #creating a particular item id must then also call on the above merchant id 
    #the item id is a creation of both the item and merchant id:
    id = create(:item, merchant_id: merchant_id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)
    expect(item[:id]).to be_a(String)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end

  it "creates an item" do 
    merchant = create(:merchant)

    item_params = ({
                    name: 'Shamwow',
                    description: 'it cleans anything',
                    unit_price: 20.11,
                    merchant_id: merchant.id 
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    
    created_item = Item.last
    
    expect(response).to be_successful 
    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "deletes an item" do 
    merchant_id = create(:merchant).id 
    id = create(:item, merchant_id: merchant_id).id

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
  end
end
