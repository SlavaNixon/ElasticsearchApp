Rails.application.routes.draw do
  root to: 'articles#index'

  resources :articles do
    collection { get :search }
    collection { get 'page/:page', to: 'articles#index' }
  end
end
