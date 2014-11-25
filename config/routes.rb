Rails.application.routes.draw do

  devise_for :admins, controllers: { confirmations: 'user/confirmations' }
  devise_for :users, controllers: { registrations: 'user/registrations', confirmations: 'user/confirmations' }
  resources :categories, only: [:index, :show] do
    get 'sub_categories', on: :collection
  end

  get 'addresses/sub_region'

  resources :requirements do
    member do
      put 'toggle_state'
      put 'toggle_interest'
      put 'fulfilled'
      put 'reject_donor', as: :reject_current_donor_of
    end
  end

  resources :donations, only: :index do
    put 'donated', on: :member
  end

  namespace :admin, path: 'admins', as: :admins do
    resources :categories do
      put 'toggle_status', on: :member
    end
    resources :users, except: :new do
      post 'search', on: :collection
      put 'toggle_status', on: :member
    end
    resources :welcome, only: :index
    resources :requirements, only: :index do
      put 'toggle_state', on: :member
      get 'filter', on: :collection
    end
  end

  root 'welcome#index'

end
