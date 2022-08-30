require 'rails_helper'

describe "Merchants API" do 
  it "sends a list of merchants" do 
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    # require 'pry'; binding.pry 
    
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    # merchants = response_body[:data]
    
    
    expect(response).to be_successful 
    expect(merchants.count).to eq(5)
    
    merchants.each do |merchant|
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:id]).to be_a(String)
    end
  end

  it "sends one particular merchant by id" do 
    
    id = create(:merchant).id 

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(merchant).to have_key(:id)
  end
end