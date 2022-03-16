Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  get 'readings/daily', to: 'readings#daily'
  post 'readings/save_daily_readings', to: 'readings#save_daily_readings'

  resources :readings, only: [:new]
  resources :users, only: [] do
    member do
      get 'reports', to: 'reports#index'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
