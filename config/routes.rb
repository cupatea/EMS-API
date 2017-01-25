Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'users' }
  # resources :users, only: [:update, :destroy]
  # resources :sessions, only: [:create, :destroy]
  resources :events do
    resources :comments, only: [:index,:create,:update,:destroy]
  end

  resources :invites, only: :create
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
