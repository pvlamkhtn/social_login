Rails.application.routes.draw do
  
  devise_for :users#, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  mount ShopifyApp::Engine, at: '/nested'
  
  get '/auth/google_oauth2/callback' => 'users/omniauth_callbacks#google_oauth2'
  get '/auth/facebook/callback' => 'users/omniauth_callbacks#facebook'

  get '/auth/shopify/callback' => 'users/omniauth_callbacks#shopify'

  root to: "home#index"
end
