Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    post   '/login',   to: 'sessions#create'
    
    resources :top, only: [:index]

    resources :studios, only: [:show] do
      scope module: :studio do
        resources :reserves, only: [:index, :create, :destroy]
      end
    end

    resources :mypage, only: [:show, :update] do
      collection do
        get :studio_reserves
        get :events
      end
    end

    resources :users, only: [:show, :create, :update] do
      collection do
        post :change_password
      end
    end

    resources :events, only: [:index, :show, :create, :edit, :update, :destroy] do
      member do
        post :entry
        post :entry_cancel
      end
      scope module: :event do
        resources :comments, only: [:index, :create, :update, :destroy]
        scope module: :sessions do
          resources :session_musics, only: [:index, :create, :show, :edit, :update, :destroy] do
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

    resources :news, only: [:index, :show, :create, :update, :destroy]
    
    # 管理者用機能
    namespace :admin do
      resources :users, only: [:index]
      resources :studios, only: [:edit, :update] do
        scope module: :studio do
          resources :reserves, only: [:index]
        end
      end
    end
  end
end
