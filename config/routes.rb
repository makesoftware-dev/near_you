Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
  end
  devise_for :users

  root "providers#index"
  resources :providers, only: [:index, :show, :new, :create, :edit, :update] do
    resources :availabilities, only: [:index, :create, :update, :destroy]
    get "available_slots", on: :member
    resources :appointments, only: [:create]
  end
  resources :appointments, only: [:index] do
    get :success, on: :member
    get :cancel, on: :member
  end

  post "/stripe/webhook", to: "stripe#webhook"
  resources :stripe_connect, only: [:create]

  resources :notifications, only: [] do
    member do
      patch :read
    end
  end
end
