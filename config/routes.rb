Rails.application.routes.draw do

  get 'people/sign_in', to: redirect('sign_in')
  get 'admins/sign_in', to: redirect('sign_in')
  get 'people/sign_up', to: redirect('users/sign_up')

  devise_scope :person do
    get 'sign_in', to: 'devise/sessions#new', as: 'person_new_session'
  end


  devise_for :people, controllers: { registrations: 'person/registrations', confirmations: 'person/confirmations' }
  devise_for :users, controllers: { registrations: 'person/registrations', confirmations: 'person/confirmations' }
  resources :categories, only: [:index, :show]

  namespace :admin do
    resources :categories do
      put 'toggle_status', on: :member
    end
    resources :users, except: :new do
      put 'toggle_status', on: :member
    end
  end

  root 'welcome#index'
  get 'admin/welcome', to: 'welcome#admin_welcome'

end
