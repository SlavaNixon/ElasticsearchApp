Rails.application.routes.draw do
  root to: 'articles#index'
  resources :articles do
    collection { get :search }
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
