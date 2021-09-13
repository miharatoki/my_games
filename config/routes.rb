Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :users, only: [:index, :show, :edit, :update] do
    get '/genre_search' => 'users#genre_search'
    get '/title_search' => 'users#title_search'
  end

  get 'posts/title_search' => 'posts#title_search'
  get 'posts/genre_search' => 'posts#genre_search'
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
