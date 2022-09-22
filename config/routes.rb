Rails.application.routes.draw do

# 顧客用
# URL /users/sign_in ...
devise_for :users, skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}
scope module: :user do
  root 'homes#top'
  # タグの検索
  get "search_tag"=>"posts#search_tag"
  resources :users, only: [:show, :edit, :update]
  resources :favorites, only: [:index]
  resources :messages, only: [:create,:destroy]
  resources :rooms, only: [:create,:show]
  resources :posts, only: [:index, :show, :edit, :new, :create, :update, :destroy, :ranking] do
    collection do
      get :search
    end
    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
end

get "users/:id/unsubscribe" => "user/users#unsubscribe", as: "unsubscribe"
patch "users/:id/withdraw" => "user/users#withdraw", as: "withdraw"


#ゲストログイン
devise_scope :user do
  post 'users/guest_sign_in', to: 'user/sessions#guest_sign_in'
end

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
  root 'homes#top'
  resources :users, only: [:index, :show, :edit, :update]
  resources :posts, only: [:index, :show, :destroy] do
    resources :comments, only: [:destroy]
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
