Rails.application.routes.draw do
  get 'images/', to: 'images#list'
  get 'images/index'
  post 'images', to: 'images#create'

  post 'favorites', to: 'favorites#create'

  post 'users', to: 'users#create'
  post 'users/start_session', to: 'users#start_session'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
