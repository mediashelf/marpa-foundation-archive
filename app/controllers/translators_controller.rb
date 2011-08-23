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
    @translator = Translator.new
  end

  def create
    @translator = Translator.new(params[:translator])
    if (@translator.save)
        redirect_to(edit_program_path(params[:program]), :notice => 'Translator was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
end
