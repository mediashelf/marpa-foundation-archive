class TranslatorsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  
  ### hydra-head 3.0.0pre3 and later should do this automatically
  # before_filter :require_solr, :require_fedora, :only=>[:show, :edit, :index, :delete, :new, :create]  


  # This applies appropriate access controls to all solr queries
  TranslatorsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def index
    @translators = Translator.find(:all)
  end
  
  def new
    @translator = Translator.new
  end
  
  def edit
    @translator = Translator.find(params[:id])
  end

  def create
    @translator = Translator.new(params[:translator])
    @translator.apply_depositor_metadata(current_user.login)
    if (@translator.save)
      if params[:program]
        redirect_to(edit_program_path(params[:program]), :notice => 'Translator was successfully created.') 
      else
        render :action=>"edit"
      end
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @translator = Translator.find(params[:id])
    @translator.update_attributes(params[:translator])
    redirect_to edit_translator_path(params[:translator])
  end
  
  def destroy
    @translator = Translator.find(params[:id])
    if @translator.delete
      flash[:notice] = "Deleted #{@translator.tibetan_name}"
    else
      flash[:error] = "Could not delete #{@translator.tibetan_name}."
    end
    redirect_to translators_path
  end
  
  def show
    redirect_to edit_translator_path(@translator)
  end
end
