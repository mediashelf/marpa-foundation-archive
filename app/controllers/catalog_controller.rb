#
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#

# Load Blacklight's ApplicationController first
require_dependency "vendor/plugins/hydra_repository/app/controllers/application_controller.rb"

class ApplicationController 
  
  def default_html_head
  
    javascript_includes << ['http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js', 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js']
    javascript_includes << ['application']
    
    javascript_includes << ['blacklight', 'application', { :plugin=>:blacklight } ]
    
    stylesheet_links << ['yui', 'jquery/ui-lightness/jquery-ui-1.8.1.custom.css', 'application', {:plugin=>:blacklight, :media=>'all'}]
    stylesheet_links << ['redmond/jquery-ui-1.8.5.custom.css', {:media=>'all'}]      
    stylesheet_links << ['styles', 'hydrangea', "hydrangea-split-button.css", {:media=>'all'}]
  end 


end
