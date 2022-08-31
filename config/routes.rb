Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
      get "/merchants/find", to: "merchant#find"
      get "/items/find_all", to: "items#find_all"
      resources :items, only: [:index, :show, :create, :destroy, :update] do 
      end
      resources :merchants, only: [:index, :show] do 
        resources :items, controller: 'merchant_items'
      end
      resources :items do 
        resources :merchant, only: [:index], controller: 'items_merchant'
      end
    end
  end
end
