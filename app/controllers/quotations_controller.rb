class QuotationsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls, :only=>[:show, :index, :edit]
  

  # This applies appropriate access controls to all solr queries
  QuotationsController.solr_search_params_logic << :add_access_controls_to_solr_params

  
  def create
    @talk = Talk.find(params[:talk])
    @quotation = Quotation.new(params[:quotation])
    apply_depositor_metadata(@quotation)
    if (@talk.save && @quotation.save)
        redirect_to(edit_quotation_path(@quotation, :talk=>@talk), :notice => 'Quotation was successfully created.') 
    else 
      render :action=>"edit"
    end
  end
  
  def update 
    @quotation = Quotation.find(params[:id])
    @quotation.update_attributes(params[:quotation])
    redirect_to edit_talk_path(params[:talk])
  end

  def edit
    @quotation = Quotation.find(params[:id])
  end 
end
