Bestmix::Application.routes.draw do
  get "my_posts/index"
  get "my_posts/create"

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount Doorkeeper::Engine => '/oauth'

  # accept get method to support scribe-java
  get 'oauth/token' => 'doorkeeper/tokens#create'

  devise_for :users

  namespace :api do
    api_version(:module => "V1", :path => "/v1") do
      resources :posts, only: [:index, :show] do
        resources :reports, only: [:index, :show, :destroy]
      end
      resources :my_posts, except:  [:edit, :new] do
        resources :reports, only: [:index, :show]
        resources :stations, only: [:index] do
          resources :reports, only: [:index]
        end
      end
      resources :users, only: [:show]
    end
  end

  resources :posts

  resources :reports, only: [:create] do
    get :autocomplete_station, :on => :collection
    get :autocomplete_config, :on => :collection
    # Search box
    collection do
      get :search
      post :import
    end
  end

  resources :products, except: [:show, :new, :edit] do
    resources :my_posts, only: [:index, :show, :destroy] do
      resources :reports, only: [:show] do
        get :autocomplete_station_name, :on => :collection
        get :autocomplete_report_config, :on => :collection
        # Search box
        collection do
          get :search
        end
        resources :configs, only: [:index]
      end
      resources :stations, only: [:show]
      resources :yield_files, only: [:index, :show, :destroy] do
        collection do
          delete :destroy_multiple
        end
      end
    end
  end

  # For Global Search Box
  match "/update_builds_selector" => "products#update_builds_selector"
  # For Build Dropdown Menu
  match "/update_builds_menu" => "products#update_builds_menu"
  # Check if user's password correct before delete account
  match "/delete_account" => "accounts#checkpass"

  match "/search_report" => "reports#search"

  root :to => 'main#index'

  get '*anything' => 'errors#routing_error'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
