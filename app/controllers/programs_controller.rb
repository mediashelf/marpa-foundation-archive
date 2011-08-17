class ProgramsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Catalog
  include Hydra::AssetsControllerHelper
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  before_filter :enforce_access_controls, :only=>[:edit, :update]
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show
  # This applies appropriate access controls to all solr queries
  ProgramsController.solr_search_params_logic << :add_access_controls_to_solr_params

  def create
    @program = Program.new()
    apply_depositor_metadata(@program)
    @program.save
    redirect_to edit_program_path(@program)
  end

  def edit
    @program = Program.find(params[:id])
  end
  
  def update
    @program = Program.find(params[:id])
    @program.update_attributes(params[:program])
    @program.save
    redirect_to edit_program_path(@program)
    
  end

  def show
    redirect_to edit_program_path(@program)
  end
  
  
end
