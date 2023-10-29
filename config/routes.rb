Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations' 
  }

  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :jobs do
    collection do 
      get :scrape
    end
    member do 
      post :addJob
    end
  end

  resources :users do
    resources :jobs do
      collection do
          get :miniIndex
      end
    end
  end

  root "jobs#home"
end
