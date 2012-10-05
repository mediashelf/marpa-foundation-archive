class TopicsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TopicsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def index
    @topics = Topic.find(:all)
  end
    
  def create
    @topic = Topic.new(params[:topic])
    apply_depositor_metadata(@topic)
    
    unless params[:talk].nil?
      @talk = Talk.find(params[:talk])
      @talk.topics << @topic
      @talk.save
    end
    
    if (@topic.save)
        redirect_to(edit_topic_path(@topic, :talk=>@talk), :notice => 'Topic was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    if !params[:talk].nil? && !params[:talk].empty? 
      redirect_to edit_talk_path(params[:talk])
    elsif !params[:program].nil? && !params[:program].empty?
      redirect_to edit_program_path(params[:program])
    else
      render :action=>"edit"
    end
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.english_title
    if @topic.delete
      flash[:notice] = "Deleted #{name}"
    else
      flash[:error] = "Could not delete #{name}."
    end
    redirect_to topics_path
  end

  def edit
    @topic = Topic.find(params[:id])
  end 
  
  def show
    redirect_to edit_topic_path(@topic)
  end
end
