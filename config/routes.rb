Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'
  post 'auth/signup', to: 'users#create'

  resources :categories
  resources :properties
  put 'add_geo_location', to: 'properties#add_geo_location'
  get 'geo_location', to: 'properties#geo_location_item'
  put 'add_favourites', to: 'properties#add_favourites'
  get 'my_favourites', to: 'properties#favourites'
end
