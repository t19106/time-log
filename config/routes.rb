Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get '/tasks/:year/:month', to: 'tasks#index'
  resources :users, only: %i(new create)
end
