Rails.application.routes.draw do
  root "splats#index"

  resource :session
  resources :splats

  get "up" => "rails/health#show", as: :rails_health_check
end
