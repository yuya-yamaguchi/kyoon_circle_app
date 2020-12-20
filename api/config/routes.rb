Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    mount_devise_token_auth_for "User", at: "auth"

    resources :top, only: [:index]
  end
end
