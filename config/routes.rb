Rails.application.routes.draw do
  get 'application/', to: 'application#index'

  get 'images/', to: 'images#view'
  get 'images/index'
  post 'images', to: 'images#create'

  post 'favorites', to: 'favorites#create'

  post 'users', to: 'users#create'
  post 'users/login', to: 'users#login'
  post 'users/logout', to: 'users#logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
