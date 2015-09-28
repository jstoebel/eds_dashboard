Rails.application.routes.draw do

  #A resource must be top level before it can be nested in another resource (I think)
  
  # match ':controller(/:action(/:id))', :via => [:get, :post]

  resources :access, only: [:index]
  resources :praxis_results, only: [:new, :create] 

  resources :clinical_sites, only: [:index, :edit, :update, :new, :create], shallow: true do
    resources :clinical_teachers, only: [:index]
  end

  resources :clinical_teachers, only: [:index, :new, :create, :edit, :update]

# resources :clinical_teachers, only: [:index, :edit, :update, :new, :create]

  resources :adm_tep, only: [:index, :show, :new, :create, :edit, :update] do
    post "choose"
    get "admit"
    get "download"
  end

  resources :adm_st, only: [:index, :show, :new, :create, :edit, :update] do
    post "choose"   #choose a term to display in index
    get "admit"
    get "download"  #download admission letter
  end

  resources :prog_exits, only: [:index, :show, :new, :create] do
    post "choose"   #choose a term to display in index
  end

  resources :clinical_assignments, only: [:index, :new, :create, :edit, :update] do
    post "choose"
  end

  resources :students, only: [:index, :show], shallow: true do
    resources :praxis_results, only: [:index, :show]
    resources :issues, only: [:index, :new, :create]
    # resources :adm_st, only: [:show]
    # resources :adm_tep, only: [:show]
  end

  resources :issues, shallow: true do
    get "resolve_issue"
    post "close_issue"
    resources :issue_updates
  end

  resources :banner_terms, shallow: true do
    resources :adm_tep, only: [:index]
    resources :adm_st, only: [:index]
    resources :prog_exits, only: [:index]
    resources :clinical_assignments, only: [:index]
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root 'students#index'
end