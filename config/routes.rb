Rails.application.routes.draw do

  devise_for :users
  resources :events do
    resources :comments, only: [:index,:create,:update,:destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
