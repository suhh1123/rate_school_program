Rails.application.routes.draw do
  # session routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"

  # user routes
  resources :users, only: [:show, :update]

  # school routes
  resources :schools, only: [:index, :create, :show]

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