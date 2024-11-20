Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
  end
  devise_for :users

  root "providers#index"
  resources :providers, only: [:index, :show, :new, :create, :edit, :update]
  resources :appointments, only: [:create, :index] do
    get :success, on: :member
    get :cancel, on: :member
  end

  resources :stripe_connect, only: [:create]
end
