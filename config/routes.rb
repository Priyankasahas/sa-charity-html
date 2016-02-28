Rails.application.routes.draw do
  root 'welcome#show'
  resources :sessions
  resource :welcome, only: :show
end
