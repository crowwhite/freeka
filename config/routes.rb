Rails.application.routes.draw do

  devise_for :admins, controllers: { confirmations: 'user/confirmations' }
  devise_for :users, controllers: { registrations: 'user/registrations', confirmations: 'user/confirmations' }
  resources :categories, only: [:index, :show] do
    get 'sub_categories', on: :collection
  end

  get 'addresses/sub_region'

  resources :requirements do
    post 'search', on: :collection
    get 'filter', on: :collection
    resources :donor_requirements, only: :create
    delete 'uninterest', to: 'donor_requirements#destroy'
    member do
      put 'toggle_state'
      put 'toggle_interest'
      put 'fulfill'
      put 'reject_donor', as: :reject_current_donor_of
    end
  end

  resources :donations, only: :index do
    put 'donate', on: :member
  end

  namespace :admin, path: 'admins', as: :admins do
    resources :categories, except: :show do
      put 'toggle_status', on: :member
    end
    resources :sub_categories, only: [:index, :new]
    resources :users, except: :new do
      post 'search', on: :collection
      put 'toggle_status', on: :member
    end
    resources :welcome, only: :index
    resources :requirements, only: :index do
      put 'toggle_state', on: :member
      post 'search', on: :collection
      get 'filter', on: :collection
    end
  end

  root 'welcome#index'

end
