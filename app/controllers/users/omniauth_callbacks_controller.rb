class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback("facebook")
  end

  def google_oauth2
    generic_callback( "google_oauth2" )
  end

  def failure
    redirect_to root_path
  end

  private

  def generic_callback(provider)
    auth = request.env["omniauth.auth"]
    identity = Identity.from_omniauth(auth)
    
    user = identity.user

    if user.blank?
      user = User.from_omniauth(auth)
    end

    if user.persisted?
      identity.user = user
      identity.save

      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      identity.destroy
      
      session["devise.#{provider}_data"] = auth
      redirect_to new_user_registration_url
    end
  end
end