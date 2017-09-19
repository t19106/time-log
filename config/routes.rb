Rails.application.routes.draw do
  get 'tasks/index'

  get '/tasks/:year/:month', to: 'tasks#index'
  resources :users, only: %i(new create)
end
