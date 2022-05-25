Rails.application.routes.draw do
  # session routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"

  # user routes
  resources :users, only: [:show, :update]
  put 'user/upload_avatar', to: "users#upload_avatar"

  # school routes
  resources :schools, only: [:index, :create, :show]
  get '/search/schools', to: "schools#search"

  # program routes
  resources :schools do
    resources :programs, shallow: true, only: [:index, :create, :show]
  end
  resource :programs, only: [:show]

  # comment routes
  resources :programs do
    resources :comments, shallow: true, only: [:index, :create, :show]
  end
  resource :comments, only: [:show]
end