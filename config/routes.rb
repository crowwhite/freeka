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
    #TODO -> Make this route as member route of categories.
    put 'categories/:id', to: 'categories#toggle_status', as: 'category_toggle_status'
    resources :categories
    #TODO -> Make this route as member route of categories.
    put 'users/:id', as: 'user_toggle_status', to: 'users#toggle_status'
    resources :users, except: :new
  end

  root 'welcome#index'
  get 'admin/welcome', to: 'welcome#admin_welcome'

end
