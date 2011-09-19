class PlacesController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  
  ### hydra-head 3.0.0pre3 and later should do this automatically
  # before_filter :require_solr, :require_fedora, :only=>[:show, :edit, :index, :delete, :new, :create]  


  # This applies appropriate access controls to all solr queries
  PlacesController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def new
    @place = Place.new
  end

  def create
    @place = Place.new(params[:place])
    apply_depositor_metadata(@place)
    
    if (@place.save)
      unless params[:program].nil?
        redirect_to(edit_program_path(:id=>params[:program]), :notice => 'Place was successfully created.') 
      else
        render :action=>"edit"
      end
    else 
      render :action=>"edit"
    end
  end

  def index
    @places = Place.find(:all)
  end
    
  def edit
    @place = Place.find(params[:id])
  end 
  
  def show
    redirect_to edit_place_path(@place)
  end
  
  def update 
    @place = Place.find(params[:id])
    @place.update_attributes(params[:place])
    if !params[:talk].nil? && !params[:talk].empty? 
      redirect_to edit_talk_path(params[:talk])
    elsif !params[:program].nil? && !params[:program].empty?
      redirect_to edit_program_path(params[:program])
    else
      render :action=>"edit"
    end
  end
  
  def destroy
    @place = Place.find(params[:id])
    name = @place.name
    if @place.delete
      flash[:notice] = "Deleted #{name}"
    else
      flash[:error] = "Could not delete #{name}."
    end
    redirect_to places_path
  end
end
