Rails.application.routes.draw do
  devise_scope :admin do
    get 'admin', to: 'devise/sessions#new'
  end
  devise_for :admins, controllers: { confirmations: 'user/confirmations' }
  devise_for :users, controllers: { registrations: 'user/registrations', confirmations: 'user/confirmations', sessions: 'user/sessions' }
  resources :categories, only: [:index, :show] do
    get 'sub_categories', on: :collection
  end

  get 'addresses/sub_region'

  resources :requirements do
    post 'search', on: :collection
    get 'filter/:category_name', to: 'requirements#filter', on: :collection, as: 'filter'
    resources :donor_requirements, only: :create
    put 'mark_donated', to: 'donor_requirements#mark_donated'
    delete 'uninterest', to: 'donor_requirements#destroy'
    member do
      put 'toggle_state'
      put 'toggle_interest'
      put 'fulfill'
      put 'reject_donor', as: :reject_current_donor_of
    end
    resources :comments, only: :create
  end

  resources :donations, only: :index do
    put 'donate', on: :member
  end

  resources :users, only: :show

  resources :coin_adjustments, only: [:index, :new, :create]

  namespace :admin, path: 'admins', as: :admins do
    resources :categories do
      put 'toggle_status', on: :member
    end
    resources :sub_categories, only: [:index, :new]
    resources :users, except: :new do
      post 'search', on: :collection
      put 'toggle_status', on: :member
    end
    resources :welcome, only: :index
    resources :requirements, only: [:index, :show] do
      put 'toggle_state', on: :member
      post 'search', on: :collection
      get 'filter/:category_name', to: 'requirements#filter', on: :collection, as: 'filter'
    end
  end

  root 'welcome#index'

end
