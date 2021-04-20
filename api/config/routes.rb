Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    post '/login', to: 'sessions#create'

    resources :top, only: [:index]

    resources :studios, only: [:show] do
      scope module: :studio do
        resources :reserves, only: [:index, :show, :create, :destroy, :update]
      end
    end

    resources :stayrooms, only: [:index] do
      scope module: :stayroom do
        resources :reserves, only: [:index, :show, :create, :destroy]
      end
    end

    resources :mypage, only: [:show, :update] do
      collection do
        get :studio_reserves
        get :events
        get :stayroom_reserves
      end
    end

    resources :users, only: %i[show create update] do
      collection do
        post :change_password
        post :reset_password_email
        get  :reset_password_token_check
        post :reset_password
      end
      member do
        get :following
        get :followers
      end
      scope module: :users do
        resources :messages, only: [:index, :create]
      end
    end

    resources :relationships, only: [:create, :destroy]

    resources :events, only: %i[index show create edit update destroy] do
      member do
        post :entry
        post :entry_cancel
      end
      scope module: :event do
        resources :comments, only: %i[index create update destroy]
        scope module: :sessions do
          resources :session_musics, only: %i[index create show edit update destroy] do
            resources :session_parts do
              member do
                post 'entry'
                post 'cancel'
              end
            end
          end
        end
      end
    end

    resources :event_categories, only: [:index]

    resources :part_categories, only: [:index]

    resources :news, only: %i[index show create update destroy]

    resources :played_musics, only: %i[index]

    # 管理者用機能
    namespace :admin do
      resources :users, only: [:index]
      resources :studios, only: %i[edit update] do
        scope module: :studio do
          resources :reserves, only: [:index]
        end
      end
    end
  end
end
