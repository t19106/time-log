Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get '/tasks/:year/:month', to: 'tasks#index'
  get '/tasks/:year/:month/:day', to: 'tasks#show'
  resources :users, only: %i(new create)
  resources :subtasks, only: %i(create)
end
