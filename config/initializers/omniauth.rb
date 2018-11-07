Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify,
           ShopifyApp.configuration.api_key,
           ShopifyApp.configuration.secret,
           scope: ShopifyApp.configuration.scope,
           setup: lambda { |env|
             strategy = env['omniauth.strategy']

             shopify_auth_params = strategy.session['shopify.omniauth_params']&.with_indifferent_access
             shop = if shopify_auth_params.present?
               "https://#{shopify_auth_params[:shop]}"
             else
               ''
             end

             strategy.options[:client_options][:site] = shop
           }

  provider :google_oauth2,
            ENV['GOOGLE_OAUTH2_APP_ID'],
            ENV['GOOGLE_OAUTH2_APP_SECRET'],
          { cope: "email" }

  provider :facebook,
            ENV['FACEBOOK_APP_ID'],
            ENV['FACEBOOK_APP_SECRET'],
          { cope: "email" }
end
