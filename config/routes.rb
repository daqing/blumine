Blumine::Application.routes.draw do
  get 'register' => 'users#new'
  get '/search/:keyword' => 'issues#search'
  get 'rebuild_index' => 'issues#rebuild_index'
  get '/stats' => "pages#stats"

  post '/user_sessions' => "user_sessions#create"
  get 'logout' => "user_sessions#destroy"

  post '/assigned_issues/sort' => 'issue_assignments#sort'
  
  resources :activities, :only => :create
  resources :users, :comments, :replies
  resources :document_sections do
    collection do
      post :sort
    end
  end
  resources :projects do
    resources :issues do
      collection do
        get 'new/:label' => 'issues#new'
        get 'filter/:state', :action => 'index'
        get 'label/:label', :action => 'view_by_label'
      end
    end
    resources :milestones do
      resources :issues
    end

    resources :activities, :uploads
    resources :conversations do
      resources :replies
    end
    resources :documents do
      resources :sections, :controller => 'document_sections'
    end

    resources :members, :controller => :project_members
  end

  resources :issues do
    resources :comments
    resources :todo_items

    member do
      post 'change_state'
      post 'assign_to'
      post 'planning'
    end

    collection do
      get 'autocomplete'
    end
  end

  resources :todo_items do
    member do
      post :change_state
    end

    collection do
      post :sort
    end
  end

  resource :account
  resources :images, :only => [:new, :create, :destroy]

  namespace 'sudo' do
    resources :users
  end

  root :to => "pages#index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
