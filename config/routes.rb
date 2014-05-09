Default::Application.routes.draw do

  devise_for :users
  
  resources :tags, only: [:index], :constraints => {:format => /(json)/}
  
  get :import, to: 'import#index'
  post :import, to: 'import#start'
  post :export, to: 'export#index'
  
  resources :users, path: 'users'
  
  namespace :api do
    match :posts_add, path: '/posts/add', to: 'posts#add', via: [:get, :post]
    match :posts_add_dep, path: '/posts_add.php', to: 'posts#add', via: [:get, :post]
    get :posts_all, path: '/posts/all', to: 'posts#all'
    get :posts_all_dep, path: '/posts_all.php', to: 'posts#all'
    match :posts_delete, path: '/posts/delete', to: 'posts#delete', via: [:get, :post]
    match :posts_delete_dep, path: '/posts_delete.php', to: 'posts#delete', via: [:get, :post]
    get :posts_update, path: '/posts/update', to: 'posts#update'
  end
  
  resources :posts, path: '/'
  root 'posts#index'
  
  resources :users, only: [], path: 'user' do
    get :posts, path: '/', controller: :posts, action: :index
    resources :tags, only: [], path: 'tag' do
      get :posts, path: '/', controller: :posts, action: :index
    end
  end
  
  resources :tags, only: [], path: 'tag' do
    get :posts, path: '/', controller: :posts, action: :index
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
