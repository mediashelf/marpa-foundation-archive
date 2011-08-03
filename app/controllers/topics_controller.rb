class TopicsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TalksController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def new
    @talk = Talk.find(params[:talk])
    @topic = Topic.new
  end

  def create
    talk = params[:talk]
    @topic = Topic.new(params[:topic])
    if (@topic.save)
        redirect_to(edit_talk_path(talk), :notice => 'Topic was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
end
