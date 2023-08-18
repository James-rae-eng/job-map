Rails.application.routes.draw do

  resources :jobs do 
    collection do 
      get :scrape
    end
  end

  resources :maps

  #root "maps#show"
  root "jobs#index"
end
