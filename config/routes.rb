Rails.application.routes.draw do
  root to: 'articles#index'

  resources :articles do
    collection { get :search }
  end

  get 'articles/page/:page', to: 'articles#index'
end
