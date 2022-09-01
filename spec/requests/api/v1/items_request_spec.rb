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

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)

  end

  it "updates an existing item" do 
    merchant_id = create(:merchant).id 
    id = create(:item, merchant_id: merchant_id).id
    previous_name = Item.last.name 

    item_params = ({
                    name: 'OxyClean',
                    description: 'it cleans anything',
                    unit_price: 20.11,
                    merchant_id: merchant_id 
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful 
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('OxyClean')
    #edge case - bad merchant id should return 404 or 400 error
    #application controller has a method for this - need to implement it
  end

  it "find all items by name fragment" do 
    merchant_id = create(:merchant).id 
    item1 = Item.create!(name: "harukane", description: 'this is an item', unit_price: 11.23, merchant_id: merchant_id)
    item2 = Item.create!(name: "harukone", description: 'this is also an item', unit_price: 10.23, merchant_id: merchant_id)
    item3 = Item.create!(name: "egg", description: 'more item', unit_price: 2.23, merchant_id: merchant_id)

    get "/api/v1/items/find_all?name=hArU"

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    # data = items[:data]
    # require 'pry'; binding.pry 

    expect(response).to be_successful
    expect(items.count).to eq(2)

    items.each do |item|
      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end

    get "/api/v1/items/find_all?name=xR"

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry 
    expect(response).to be_successful
    expect(items.count).to eq(0)
    expect(response.body).to eq("{\"data\":[]}")
    
    # items.each do |item|
    #   expect(item).to_not have_key(:attributes)
    #   expect(item.response.body).to eq({})
    # end
  end
end

  # it "can find items by price" do 
  #   merchant_id = create(:merchant).id 
  #   item1 = Item.create!(name: "harukane", description: 'this is an item', unit_price: 11.23, merchant_id: merchant_id)
  #   item2 = Item.create!(name: "harukone", description: 'this is also an item', unit_price: 10.23, merchant_id: merchant_id)
  #   item3 = Item.create!(name: "egg", description: 'more item', unit_price: 50.00, merchant_id: merchant_id)

  #   get "/api/v1/items/find?min_price=50"

  #   items = JSON.parse(response.body, symbolize_names: true)[:data]
  #   # require 'pry'; binding.pry 
  #   expect(response).to be_successful 
  #   expect(response.status).to eq(200)

  #   get "/api/v1/items/find?min_price=40"

  #   items = JSON.parse(response.body, symbolize_names: true)[:data]

  #   expect(items).to eq([])
  #   expect(response.body).to include("something")
  # end










  # it "raises an error if a non-existing merchant id is used" do 
  #   merchant1 = create(:merchant).id 
  #   merchant2 = create(:merchant).id 
  #   id = create(:item, merchant_id: merchant1).id

  #   item_params = ({
  #                   name: 'OxyClean',
  #                   description: 'it cleans anything',
  #                   unit_price: 20.11,
  #                   merchant_id: merchant2
  #                 })

  #   headers = {"CONTENT_TYPE" => "application/json"}

  #   put "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
  #   item = Item.find_by(id: id)

  #   expect(response.status).to eq(404)
  # end

