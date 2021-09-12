Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/edit'
  devise_for :users
  root to: 'homes#top'
  resources :users, only: [:index, :show, :edit, :update] do
    get 'users/:id/genres/:id' => 'genres#show'
  end
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
