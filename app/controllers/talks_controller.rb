class TalksController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  #before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TalksController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  #def new
  #  @course = MarpaCourse.find(params[:course])
  #  @talk = Talk.new
  #end
  def index
    render :text=>"indux"
  end

  def edit
    @talk = Talk.find(params[:id])
    @course = @talk.courses.first
  end

  def create
    @course = MarpaCourse.find(params[:course])
    @talk = Talk.new(params[:talk])
    @talk.courses_append @course
    if (@talk.save)
      redirect_to(edit_talk_path(@talk), :notice => 'Talk was successfully updated.') 
    end
  end

  def update
    @talk = Talk.find(params[:id])
    if (@talk.update_attributes(params[:talk]))
        redirect_to(edit_catalog_path(@talk.courses.first), :notice => 'Talk was successfully updated.') 
    else 
      render :action=>"edit"
    end
  end
  def add_song
    @talk = Talk.find(params[:id])
    @song = Song.find(params[:song])
    @talk.songs_append @song
    @talk.save
    render :partial=>'song', :locals=>{:song=>@song}
  end

  def add_text
    @talk = Talk.find(params[:id])
    @text = Text.find(params[:text])
    @talk.texts_append @text
    @talk.save
    render :partial=>'text', :locals=>{:text=>@text}
  end
end
