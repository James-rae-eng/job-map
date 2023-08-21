Rails.application.routes.draw do

  resources :jobs do 
    collection do 
      get :scrape
    end
    resources :maps
  end

  root "jobs#index"
end
