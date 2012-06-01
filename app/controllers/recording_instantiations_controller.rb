class RecordingInstantiationsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  RecordingsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    # If this talk doesn't have a recording already, then create a recording.
    #set talk on recording
    @talk = Talk.find(params[:talk_id])
    raise RuntimeError, "Couldn't find talk for #{params[:talk_id]}" unless @talk
    
    @recording = @talk.recordings.first || Recording.create(:talk_id => @talk)

    @instantiation = RecordingInstantiation.new(params[:recording_instantiation])
    @instantiation.recording = @recording
    #TODO why does @instantiation.talk = @recording.talk fail?
    @instantiation.talk_id = @recording.talk.pid
    @instantiation.save  ### NEED TO SAVE BEFORE UPLOADING TO S3
    @instantiation.file_content = params[:files][0]
    apply_depositor_metadata(@instantiation)
    if (@instantiation.save)
      render :json => [@instantiation.to_jq_upload].to_json
    else 
      render :action=>"edit"
    end
  end

  def index
    #TODO only those for this talk
    # @talk = Talk.find(params[:talk_id])
    # raise RuntimeError, "Couldn't find talk for #{params[:talk_id]}" unless @talk
    render :json => [RecordingInstantiation.find(:all).map(&:to_jq_upload)].to_json
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
