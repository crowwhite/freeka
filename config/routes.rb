Rails.application.routes.draw do

  get 'people/sign_in', to: redirect('sign_in')
  get 'admins/sign_in', to: redirect('sign_in')

  devise_scope :person do
    get 'sign_in', to: 'devise/sessions#new', as: 'person_new_session'
  end


  devise_for :people, controllers: { confirmations: 'person/confirmations' }
  devise_for :users, controllers: { registrations: 'person/registrations', confirmations: 'person/confirmations' }
  resources :categories, only: [:index, :show]

  namespace :admin do
    #TODO -> Make only those routes which are required.
    #Fixed
    resources :categories do
      put 'toggle_status', on: :member
    end
    resources :users, except: :new do
      put 'toggle_status', on: :member
    end
    #TODO -> Make this route as member route of categories.
    #Fixed -- Want to discuss this
  end

  root 'welcome#index'
  get 'admin/welcome', to: 'welcome#admin_welcome'

end
