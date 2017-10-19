Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  resources :tasks, only: %i(create destroy)
  namespace :tasks do
    get ':year/:month', to: 'months#index', as: 'months', constraints: { year: /[0-9]{4}/, month: /[0-9]{1,2}/ }
    get ':year/:month/:day', to: 'days#index', as: 'days', constraints: { year: /[0-9]{4}/, month: /[0-9]{1,2}/, day: /[0-9]{1,2}/ }
  end
  resources :tags, except: %i(show) do
    resources :goals, on: :collection, except: %i(index show)
  end
  resources :users, only: %i(new create)
end
