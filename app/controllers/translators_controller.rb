class TranslatorsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  
  ### hydra-head 3.0.0pre3 and later should do this automatically
  before_filter :require_solr, :require_fedora, :only=>[:show, :edit, :index, :delete, :new, :create]  


  # This applies appropriate access controls to all solr queries
  TranslatorsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def new
    @place = Place.new
  end

  def create
    course = params[:course]
    @place = Translator.new(params[:translator])
    if (@place.save)
        redirect_to(edit_catalog_path(course), :notice => 'Translator was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
end
