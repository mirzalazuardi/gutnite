Rails.application.routes.draw do
  mount OasRails::Engine => '/docs'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      namespace :users, path: "users/:user_id" do
        resources :follows, only: [:create, :destroy]
        get 'followings', to: 'follows#followings'
        get 'followers', to: 'follows#followers'
        resources :sleep_records, only: [:index, :create]
      end
    end
  end
end
