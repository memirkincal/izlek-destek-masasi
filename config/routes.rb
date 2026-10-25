Rails.application.routes.draw do
  get "register", to: "registrations#new", as: :new_registration
  post "register", to: "registrations#create", as: :registrations
  resource :session
  resources :passwords, param: :token
  resources :team_members, only: %i[index create]
  resources :knowledge_articles, only: %i[index new create edit update]
  get "yardimci", to: "support_agent#show", as: :support_agent
  post "yardimci", to: "support_agent#respond"

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
