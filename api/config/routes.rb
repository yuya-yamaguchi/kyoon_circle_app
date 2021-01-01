Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    mount_devise_token_auth_for "User", at: "auth"

    resources :top, only: [:index]

    resources :studios, only: [:show] do
      scope module: :studio do
        resources :reserves, only: [:create, :destroy]
      end
    end

    resources :mypage, only: [:show, :update] do
      collection do
        get :studio_reserves
        get :events
      end
    end

    resources :events, only: [:index, :show, :create] do
      member do
        post :entry
        post :entry_cancel
      end
    end

    # 管理者用機能
    namespace :admin do
      resources :users, only: [:index]
      resources :studios, only: [:edit, :update]
    end
  end
end
