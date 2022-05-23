Rails.application.routes.draw do
  # session routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"

  # school routes
  resources :schools, only: [:index, :create, :show]

  # program routes
  resources :schools do
    resources :programs, shallow: true
  end
  resource :programs, only: [:show]

  # comment routes

end