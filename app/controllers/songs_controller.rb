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
      flash[:notice] = 'Song was successfully created.'
      if params.has_key?(:talk) && !params[:talk].empty?
        redirect_to(edit_song_path(@song, :talk=>params[:talk])) 
      else
        render :action=>"edit"
      end
    else 
      flash[:error] = 'Could not create a new Song.'
      render :action=>"edit"
    end
  end
  
  def update 
    @song = Song.find(params[:id])
    @song.update_attributes(params[:song])
    render :action=>:edit
    # redirect_to edit_song_path(params[:talk])
  end
  
  def index
    @songs = Song.find(:all)
  end
  
  def edit
    @song = Song.find(params[:id])
  end
  
  def show
    redirect_to edit_song_path(@song)
  end
  
  def destroy
    @song = Song.find(params[:id])
    @song.talks.each do |talk|
      talk.songs_remove(@song)
    end
    if @song.delete
      flash[:notice] = "Deleted #{@song.english_title} and all associations."
    else
      flash[:error] = "Could not delete #{@song.english_title}."
    end
    redirect_to songs_path
  end
end
