Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    mount_devise_token_auth_for "User", at: "auth"

    resources :top, only: [:index]

    resources :studios, only: [:show] do
      scope module: :studio do
        resources :reserves, only: [:create]
      end
    end

    resources :mypage, only: [:show, :update]

    resources :events, only: [:index, :show, :create]
  end
end
