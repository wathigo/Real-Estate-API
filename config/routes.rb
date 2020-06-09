Rails.application.routes.draw do
  resources :categories
  resources :properties
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'authenticate', to: 'authentication#authenticate'
end
