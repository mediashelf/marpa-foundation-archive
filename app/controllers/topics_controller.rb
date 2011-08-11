class TopicsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TopicsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @talk = Talk.find(params[:talk])
    @topic = Topic.new(params[:topic])
    #@topic.talks_append @talk
    @talk.topics_append @topic
    apply_depositor_metadata(@topic)
    if (@topic.save && @talk.save)
        redirect_to(edit_topic_path(@topic, :talk=>@talk), :notice => 'Topic was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    redirect_to catalog_path(:id=>params[:talk])

  end

  def edit
    @topic = Topic.find(params[:id])
  end 
end
