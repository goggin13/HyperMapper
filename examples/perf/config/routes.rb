Perf::Application.routes.draw do
  
  ## Inserts
  match "hyper_mapper/single_insert" => "Hyper#single_insert"
  match "mongoid/single_insert" => "Mongoid#single_insert"
  
  match "hyper_mapper/:id/embedded_insert" => "Hyper#embedded_insert"
  match "mongoid/:id/embedded_insert" => "Mongoid#embedded_insert"
  
  ## Updates
  match "hyper_mapper/:id/single_update" => "Hyper#single_update"
  match "mongoid/:id/single_update" => "Mongoid#single_update"
  
  match "hyper_mapper/:id/:post_id/embedded_update" => "Hyper#embedded_update"
  match "mongoid/:id/:post_id/embedded_update" => "Mongoid#embedded_update"
  
  ## Deletes
  match "hyper_mapper/:id/single_destroy" => "Hyper#single_destroy"
  match "mongoid/:id/single_destroy" => "Mongoid#single_destroy"

  match "hyper_mapper/:id/:post_id/embedded_destroy" => "Hyper#embedded_destroy"
  match "mongoid/:id/:post_id/embedded_destroy" => "Mongoid#embedded_destroy"
    
  # Queries
  match "hyper_mapper/:id/single_query" => "Hyper#single_query"
  match "mongoid/:id/single_query" => "Mongoid#single_query"

  match "hyper_mapper/:id/:post_id/embedded_query" => "Hyper#embedded_query"
  match "mongoid/:id/:post_id/embedded_query" => "Mongoid#embedded_query"
    
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
