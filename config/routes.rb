Rails.application.routes.draw do

  devise_for :admins, controllers: { confirmations: 'user/confirmations' }
  devise_for :users, controllers: { registrations: 'user/registrations', confirmations: 'user/confirmations' }
  resources :categories, only: [:index, :show]

  get 'requirements/sub_category', to: 'categories#sub_categories'
  get 'requirements/sub_region', to: 'addresses#sub_region'
  resources :requirements do
    put 'toggle_state', on: :member
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
  end

  root 'welcome#index'

end
