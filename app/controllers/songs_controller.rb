class SongsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  SongsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @song = Song.new(params[:song])
    apply_depositor_metadata(@song)
    if (@song.save)
        redirect_to(edit_song_path(@song, :talk=>params[:talk]), :notice => 'Song was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @song = Song.find(params[:id])
    @song.update_attributes(params[:song])
    redirect_to edit_talk_path(params[:talk])
  end

  def edit
    @song = Song.find(params[:id])
  end 
end
