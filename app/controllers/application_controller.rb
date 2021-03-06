class ApplicationController < ActionController::Base
  # Adds Hydra behaviors into the application controller 
   include Hydra::Controller
  protect_from_forgery
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

    rescue_from(Hydra::AccessDenied) do |exception|
      redirect_to root_url, :alert => exception.message
    end


  def layout_name
    'application'
  end


  
end
