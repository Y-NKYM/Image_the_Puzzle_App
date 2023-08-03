Rails.application.routes.draw do
  root to: 'public/homes#top'
  scope module: :public do
    get 'homes/about' => 'homes#about'
    resources :users, only:  [:index, :show, :edit, :update]
    resources :posts, only:  [:new, :index, :create, :show, :edit, :update, :destroy]
    resources :post_comments, only:  [:new, :create, :destroy]
    resources :tags, only:  [:index]
    resources :bookmarks, only:  [:index, :update, :destroy]
    resources :searches, only:  [:index]
  end

  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only:  [:index, :show, :edit, :update]
    resources :posts, only:  [:index, :show, :edit, :update]
    resources :post_comments, only:  [:index, :show, :edit, :update]
    resources :tags, only:  [:index, :destroy]
  end

  # namespace :admin do
  #   get 'post_comments/index'
  #   get 'post_comments/show'
  #   get 'post_comments/edit'
  #   get 'users/index'
  #   get 'users/show'
  #   get 'users/edit'
  #   get 'posts/index'
  #   get 'posts/show'
  #   get 'posts/edit'
  #   get 'tags/index'
  # end

  # namespace :public do
  #   get 'bookmarks/index'
  # end
  # namespace :public do
  #   get 'searches/index'
  # end
  # namespace :public do
  #   get 'tags/index'
  # end
  # namespace :public do
  #   get 'post_comments/index'
  # end
  # namespace :public do
  #   get 'users/show'
  #   get 'users/edit'
  # end
  # namespace :public do
  #   get 'posts/new'
  #   get 'posts/index'
  #   get 'posts/show'
  #   get 'posts/edit'
  # end
  # namespace :public do
  #   get 'homes/top'
  #   get 'homes/about'
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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

end
