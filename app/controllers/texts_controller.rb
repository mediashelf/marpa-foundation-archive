class TextsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  TextsController.solr_search_params_logic << :add_access_controls_to_solr_params
  
  def create
    @text = Text.new(params[:text])
    apply_depositor_metadata(@text)
    if (@text.save)
        redirect_to(edit_text_path(@text, :talk=>params[:talk]), :notice => 'Text was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @text = Text.find(params[:id])
    @text.update_attributes(params[:text])
    redirect_to edit_talk_path(params[:talk])
  end

  def edit
    @text = Text.find(params[:id])
  end 
end
