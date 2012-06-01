class TalksController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  #before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TalksController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def index
    render :text=>"indux"
  end

  def edit
    @talk = Talk.find(params[:id])
    @recording_instantiation = RecordingInstantiation.new
    @program = @talk.program
  end
  
  def show
    redirect_to edit_talk_path(@talk)
  end

  def create
    @program = Program.find(params[:program])
    @talk = Talk.new(params[:talk])
    @talk.program = @program
    if (@talk.save)
      redirect_to(edit_talk_path(@talk), :notice => 'Talk was successfully created.') 
    end
  end

  def update
    @talk = Talk.find(params[:id])
    if (@talk.update_attributes(params[:talk]))
      if params[:program].nil?
        flash[:notice] = 'Talk was successfully updated.'
        redirect_to edit_talk_path(@talk)
      else
        redirect_to(edit_program_path(params[:program]), :notice => 'Talk was successfully updated.') 
      end
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

  def add_talk_text
    @talk = Talk.find(params[:id])
    @text = Text.find(params[:text_id])
    @talk_text = TalkText.new(:talk=>@talk, :text=>@text)
    @talk_text.save
    render :partial=>'nested_texts', :locals=>{:talk_text=>@talk_text}
  end
  
  def remove_talk_text
    @talk_text = TalkText.find(params[:id])
    @talk = @talk_text.talk
    if @talk_text.delete
      redirect_to(edit_talk_path(@talk), :notice => 'Text association was successfully deleted.') 
    else
      redirect_to(edit_talk_path(@talk), :notice => 'Could not delete text association.') 
    end
  end

  def add_quotation
    @talk = Talk.find(params[:id])
    @quotation = Quotation.find(params[:quotation])
    @talk.quotations_append @quotation
    @talk.save
    render :partial=>'quotation', :locals=>{:quotation=>@quotation}
  end
end
