class RecordingInstantiationFilesController < ApplicationController
  # include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper
  

  # These before_filters apply the hydra access controls
  # before_filter :enforce_access_controls, :only=>[:show, :index, :edit]

  def create
    if params.has_key?(:Filedata) && params[:Filedata].is_a?(Array)
      @instantiation = RecordingInstantiation.find(params[:recording_instantiation_id])
      result = @instantiation.file_content = params[:Filedata].first
      if result
          flash[:notice] = 'File upload was successful.'
      else 
        flash[:error] =  'File upload failed.'
      end
    else
      flash[:error] = 'You must select a file to upload.'
    end
    redirect_to( edit_recording_instantiation_path(params[:recording_instantiation_id]) )
  end
  
end
