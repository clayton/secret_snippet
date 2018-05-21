Rails.application.routes.draw do
  resource :secrets
  root to: 'secrets#new'
end
