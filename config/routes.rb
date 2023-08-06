Rails.application.routes.draw do
    # 顧客用
  # URL /customers/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  root to: 'public/homes#top'
  scope module: :public do
    # ゲスト用
    devise_scope :user do
      post "users/guest_sign_in", to: "users#guest_sign_in"
    end

    get 'about' => 'homes#about'
    get 'users/mypage' => 'users#mypage'
    resources :users, only:  [:show]
    get 'users/introduction/edit' => 'users#edit'
    patch 'users/introduction' => 'users#update'
    patch 'users/withdraw' => 'users#withdraw'
    resources :bookmarks, only:  [:index]
    resources :posts, only:  [:new, :index, :create, :show, :edit, :update, :destroy] do
      resource :bookmarks, only:  [:create, :destroy]
    end
    resources :post_comments, only:  [:new, :create, :destroy]
    resources :searches, only:  [:index]
    resources :tags, only:  [:index]
  end

  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only:  [:index, :show, :edit, :update, :destroy]
    resources :posts, only:  [:index, :show, :edit, :update, :destroy]
    resources :post_comments, only:  [:index, :destroy]
    resources :tags, only:  [:index, :destroy]
    # get 'post_comments/index'
    # get 'post_comments/show'
    # get 'post_comments/edit'
    # get 'users/index'
    # get 'users/show'
    # get 'users/edit'
    # get 'posts/index'
    # get 'posts/show'
    # get 'posts/edit'
    # get 'tags/index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
