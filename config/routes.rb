Rails.application.routes.draw do
  get 'sessions/new'

  root             'static_pages#home'


  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get 'tweets/show/:name(.:format)' => 'tweets#show', as: :hashtag
  post 'tweets/retweet/(.:format)' => 'tweets#retweet', as: :retweet_act
  get 'groups/manage' => 'groups#manage', as: :manage_groups
  get '/groups/:id(.:format)/add' => 'groups#show_to_add', as: :add_members
  post '/groups/:id(.:format)/add' => 'groups#add_member', as: :add_members_db
  get  '/groups/:id/leave' => 'groups#leave_group', as: :leave_group
  get '/groups/:id(.:format)/kick' => 'groups#kick', as: :kick_group
  get '/groups/:id(.:format)/ban' => 'groups#ban', as: :ban_group
  post '/suggested' => 'users#suggest', as: :get_suggested
  post '/groups/:id(.:format)/removeban' => 'groups#remove_ban', as: :removeban_group


  resources :tweets,          only: [:create, :destroy]
  resources :followers,       only: [:create, :destroy]
  resources :groups
  resources :users do
    member do
      get :following, :followers
    end
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
end
