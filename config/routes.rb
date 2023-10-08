Rails.application.routes.draw do

  resources :jobs do 
    collection do 
      get :scrape
      get :miniIndex
    end
    member do 
    #collection do
      post :addJob
    end
  end

  root "jobs#home"
end
