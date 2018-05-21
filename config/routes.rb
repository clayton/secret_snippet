Rails.application.routes.draw do
  resources :sessions
  resources :secrets
  root to: 'secrets#new'
end
