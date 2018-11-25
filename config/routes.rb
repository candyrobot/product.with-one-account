Rails.application.routes.draw do
  get 'images/', to: 'images#list'
  get 'images/index'
  post 'images', to: 'images#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
