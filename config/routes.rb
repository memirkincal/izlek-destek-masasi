Rails.application.routes.draw do
  get "register", to: "registrations#new", as: :new_registration
  post "register", to: "registrations#create", as: :registrations
  resource :session
  resources :passwords, param: :token
  resources :team_members, only: %i[index create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "tickets#index"
  resources :tickets, only: %i[index show new create] do
    member do
      patch :assign
      patch :open
      patch :solve
      post :reopen
      post :replies
    end
  end
end
