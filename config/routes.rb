Rails.application.routes.draw do
  get '/', to: redirect('/images')

  get 'application/', to: 'application#index'

  get 'images/', to: 'images#view'
  get 'images/list'
  post 'images', to: 'images#create'

  post 'favorites', to: 'favorites#create'
  get 'favorites', to: 'favorites#list'
  delete 'favorites', to: 'favorites#destroy'

  post 'users', to: 'users#create'
  post 'users/login', to: 'users#login'
  post 'users/logout', to: 'users#logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
