class RecordingsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  RecordingsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @talk = Talk.find(params[:talk])
    @recording = Recording.new(params[:recording])
    @recording.talk = @talk
    apply_depositor_metadata(@recording)
    if (@recording.save)
        redirect_to(edit_recording_path(@recording, :talk=>params[:talk]), :notice => 'Recording was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @recording = Recording.find(params[:id])
    @recording.update_attributes(params[:recording])
    if params[:talk].nil? || params[:talk].empty?
      render :action=>"edit"
    else
      redirect_to edit_talk_path(params[:talk])
    end
  end

  def edit
    @recording = Recording.find(params[:id])
    @talk = @recording.talk
  end 
  
  def show
    redirect_to edit_recording_path(@recording)
  end
  
  def destroy
    @recording = Recording.find(params[:id])
    name = @recording.document_identifier
    
    return_to = {}
    if @recording.talk.nil?
      # do nothing
    else
      return_to[:talk] = @recording.talk.pid 
    end   
       
    if @recording.delete
      flash[:notice] = "Deleted #{name}"
    else
      flash[:error] = "Could not delete #{name}."
    end
    if return_to.has_key?(:talk)
      redirect_to edit_talk_path(return_to[:talk])
    else
      redirect_to catalog_path
    end
  end
end
