Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    resources :top, only: [:index]
  end
end
