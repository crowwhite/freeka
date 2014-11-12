Rails.application.routes.draw do

  get 'people/sign_in', to: redirect('sign_in')
  devise_scope :person do
    get 'sign_in', to: 'devise/sessions#new', as: 'person_new_session'
  end

  get 'admins/sign_in', to: redirect('sign_in')

  devise_for :people, controllers: { confirmations: 'person/confirmations' }
  devise_for :users, controllers: { registrations: 'person/registrations', confirmations: 'person/confirmations' }
  # devise_for :admins, controllers: { registrations: 'person/registrations' }
  resources :categories, only: [:index, :show]
  resources :users, except: :destroy

  namespace :admin do
    resources :categories
    put 'update_categories/:id', as: 'category_toggle_status', to: 'categories#toggle_status'
  end

  get 'admin/sub_categories/new', as: 'sub_category', to: 'admin/categories#new_sub_category'

  root 'welcome#index'
  get 'admin/welcome', to: 'welcome#admin_welcome'

end
