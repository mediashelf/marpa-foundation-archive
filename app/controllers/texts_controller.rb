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
    if !params[:talk].nil?
      redirect_to edit_talk_path(params[:talk])
    elsif !params[:program].nil?
      redirect_to edit_program_path(params[:program])
    else
      render :action=>"edit"
    end
  end
  
  def index
    @texts = Text.find(:all)
  end
  
  def edit
    @text = Text.find(params[:id])
  end 
  
  def show
    redirect_to edit_text_path(@text)
  end
  
  def destroy
    @text = Text.find(params[:id])
    if @text.delete
      flash[:notice] = "Deleted #{@text.english_title}"
    else
      flash[:error] = "Could not delete #{@text.english_title}."
    end
    redirect_to texts_path
  end
end
