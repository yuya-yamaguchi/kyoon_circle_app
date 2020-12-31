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
      end
    end

    resources :events, only: [:index, :show, :create]
  end
end
