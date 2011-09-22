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

  def upload_success
    @instantiation = RecordingInstantiation.find(params[:id])
    @instantiation.attributes=params[:upload]
    @instantiation.store_upload()
    @instantiation.save
    render :text=>"OK"
  end
  
  def update 
    @instantiation = RecordingInstantiation.find(params[:id])   
    @instantiation.update_attributes(params[:recording_instantiation])
    
    if @instantiation.save
      flash[:notice] = "Successfully updated #{@instantiation.instantiation_identifier}"
    else
      flash[:error] = "Could not update #{@instantiation.instantiation_identifier}"
    end
    
    if params[:recording].nil? || params[:recording].empty?
      redirect_to :action=>"edit"
    else
      redirect_to edit_recording_path(params[:recording])
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
  
  def destroy
    @instantiation = RecordingInstantiation.find(params[:id])
    name = @instantiation.instantiation_identifier
    
    return_to = {}
    if @instantiation.talk.nil?
      if @instantiation.recording.nil?
        #do nothing
      else
        return_to[:recording] = @instantiation.recording.pid
      end
    else
      return_to[:talk] = @instantiation.talk.pid 
    end   
       
    if @instantiation.delete
      flash[:notice] = "Deleted #{name}"
    else
      flash[:error] = "Could not delete #{name}."
    end
    if return_to.has_key?(:recording)
      redirect_to edit_recording_path(return_to[:recording])
    elsif return_to.has_key?(:talk)
      redirect_to edit_talk_path(return_to[:talk])
    else
      redirect_to catalog_path
    # if @instantiation.recording.respond_to?(:pid)
    #   redirect_to talk_path(@instantiation.recording.pid)
    # elsif @instantiation.recording.respond_to?(:pid)
    #   redirect_to recording_path(@instantiation.recording.pid)
    end
  end
  
end
