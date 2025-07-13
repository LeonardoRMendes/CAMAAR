Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get 'password_resets/:token/edit', to: 'password_resets#edit', as: :password_reset_edit
  patch 'password_resets/:token', to: 'password_resets#update', as: :password_reset_update
  
  get '/dashboard', to: 'dashboard#index'
  
  get '/avaliacoes', to: 'avaliacoes#index'
  get '/minhas_avaliacoes', to: 'avaliacoes#index'
  
  resources :formularios, only: [:show] do
    resources :respostas, only: [:create]
  end
  
  namespace :admin do
    resources :templates, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :formularios, only: [:index, :new, :create, :destroy]
    resources :importacoes, only: [:index, :create]
    resources :resultados, only: [:index, :show] do
      get :export_csv, on: :member
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"
end
