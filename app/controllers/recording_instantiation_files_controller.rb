class RecordingInstantiationFilesController < ApplicationController
  # include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper
  

  # These before_filters apply the hydra access controls
  # before_filter :enforce_access_controls, :only=>[:show, :index, :edit]

  def create
    @instantiation = RecordingInstantiation.find(params[:recording_instantiation_id])
    result = @instantiation.file_content = params[:Filedata].first
    if result
        redirect_to(edit_recording_instantiation_path(@instantiation), :notice => 'File upload was successful.') 
    else 
      render :action=>"edit", :notice => 'File upload failed.'
    end
  end
  
end
