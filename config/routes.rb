Rails.application.routes.draw do
  get '/pages/:name' => 'pages#show', as: 'page'
  resources :sessions
  resources :secrets
  root to: 'pages#show', name: "home"
end
