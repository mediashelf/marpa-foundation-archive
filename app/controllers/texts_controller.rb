class TextsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TextsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @talk = Talk.find(params[:talk])
    @text = Text.new(params[:text])
    @text.talks_append @talk
    apply_depositor_metadata(@text)
    if (@text.save)
        redirect_to(edit_text_path(@text, :talk=>@talk), :notice => 'Text was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @text = Text.find(params[:id])
    @text.update_attributes(params[:text])
    redirect_to catalog_path(:id=>params[:talk])
  end

  def edit
    @text = Text.find(params[:id])
  end 
end
