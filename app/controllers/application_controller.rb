#
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#

# Load Blacklight's ApplicationController first
require_dependency "vendor/plugins/blacklight/app/controllers/application_controller.rb"

class ApplicationController 
  
  include HydraAccessControlsHelper
  
  helper :all
  helper :hydra_access_controls, :hydra_djatoka, :downloads, :metadata, :hydra, :custom_metadata, :hydra_fedora_metadata, :hydra_assets
  
  # helper_method [:request_is_for_user_resource?]#, :user_logged_in?]
  before_filter [:store_bounce]
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '200c1e5f25e610288439b479ef176bbd'
  
  
  def default_html_head
    # when working offline, comment out the above uncomment the next line:
    #javascript_includes << ['jquery-1.4.2.min.js', 'jquery-ui-1.8.1.custom.min.js', { :plugin=>:blacklight } ]
  
    javascript_includes << ['http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js', 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js']
    javascript_includes << ['application']
    
    javascript_includes << ['blacklight', 'application', 'accordion', { :plugin=>:blacklight } ]
    
    stylesheet_links << ['yui', 'jquery/ui-lightness/jquery-ui-1.8.1.custom.css', {:plugin=>:blacklight, :media=>'all'}]
    stylesheet_links << ['hydrangea', {:media=>'all'}]
    
    stylesheet_links << ['styles', {:media=>'all'}]
    stylesheet_links << ['marpa-foundation', 'layout', 'navigation', 'application', 'marpa-foundation-styles',  {:media=>'all'}]    
  end 
      
  protected
  def store_bounce 
    session[:bounce]=params[:bounce]
  end

end
