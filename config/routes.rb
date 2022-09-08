Rails.application.routes.draw do

# 顧客用
# URL /users/sign_in ...
devise_for :users, skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}
scope module: :user do
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  resources :users, only: [:show, :edit, :update]
  resources :posts, only: [:index, :show, :edit, :new, :create, :update, :destroy] do
    collection do
      get :ranking
    end
  end
end

#ゲストログイン
devise_scope :user do
  post 'users/guest_sign_in', to: 'user/sessions#guest_sign_in'
end

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
