class PlacesController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  
  ### hydra-head 3.0.0pre3 and later should do this automatically
  before_filter :require_solr, :require_fedora, :only=>[:show, :edit, :index, :delete, :new, :create]  


  # This applies appropriate access controls to all solr queries
  PlacesController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def new
    @place = Place.new
  end

  def create
    course = params[:course]
    @place = Place.new(params[:place])
    if (@place.save)
        redirect_to(catalog_path(:id=>params[:course]), :notice => 'Place was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
end
