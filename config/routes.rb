Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 
    namespace :v1 do 
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
  # get "/api/v1/items/:id/:merchant_id", to: "items_merchant#show"
end
