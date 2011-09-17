class RecordingInstantiationsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  RecordingsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @recording = Recording.find(params[:recording])
    @instantiation = RecordingInstantiation.new(params[:recording_instantiation])
    @instantiation.recording = @recording
    @instantiation.talk = Talk.find(@recording.talk.pid)
    apply_depositor_metadata(@instantiation)
    if (@instantiation.save)
        redirect_to(edit_recording_instantiation_path(@instantiation, :recording=>params[:recording]), :notice => 'Instantiation was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @instantiation = RecordingInstantiation.find(params[:id])
    
    if params.has_key?("Filedata")
      @instantiation.store(params["Filedata"])
    else     
      @instantiation.update_attributes(params[:recording_instantiation])
      if params[:recording].nil? || params[:recording].empty?
        redirect_to :action=>"edit"
      else
        redirect_to edit_recording_path(params[:recording])
      end
    end
  end

  def edit
    @instantiation = RecordingInstantiation.find(params[:id])
    @talk = @instantiation.talk
    @recording = @instantiation.recording
  end 
  
  def show
    redirect_to edit_recording_instantiation_path(@instantiation)
  end
end
