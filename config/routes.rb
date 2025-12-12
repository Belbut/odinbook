Rails.application.routes.draw do
  # TODO: refactor routes with concerns. maybe write a personal blog post about it.

  devise_for :users
  resources :users, only: [:index] do
    resource :profile, only: %i[show]
    resources :posts, only: %i[index]
    resources :attachments, only: [:index], path: "photos"
  end

  resource :profile, only: %i[edit update]
  resources :attachments, only: %i[destroy]

  resources :posts, only: %i[show new create edit update destroy] do
    resources :comments, only: [:new], as: "reply"
  end

  resources :comments, except: %i[new index] do
    resources :comments, only: [:new], as: "reply"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "users#index"
end
