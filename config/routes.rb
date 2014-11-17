Rails.application.routes.draw do

  devise_for :admins, controllers: { confirmations: 'user/confirmations' }
  devise_for :users, controllers: { registrations: 'user/registrations', confirmations: 'user/confirmations' }
  resources :categories, only: [:index, :show]

  namespace :admin, path: 'admins', as: :admins do
    resources :categories do
      put 'toggle_status', on: :member
    end
    resources :users, except: :new do
      put 'toggle_status', on: :member
    end
  end

  get 'welcome/index'
  root 'welcome#index'
  get 'admins/welcome', to: 'welcome#admin_welcome'

end
