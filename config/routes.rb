Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'homes/guest_sign_in' => 'homes#guest_sign_in'
  resources :users, only: [:index, :show, :edit, :update] do
    get '/genre_search' => 'users#genre_search'
    get '/title_search' => 'users#title_search'
    resources :notifications, only: [:index]
    delete 'notifications' => 'notifications#destroy_all'
  end

  get 'posts/title_search' => 'posts#title_search'
  get 'posts/genre_search' => 'posts#genre_search'
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    get '/favorites' => 'favorites#create'
    delete '/favorites' => 'favorites#destroy'
  end
  

end
