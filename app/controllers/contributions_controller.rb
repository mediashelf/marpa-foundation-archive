class ContributionsController < ApplicationController
  include Hydra::RepositoryController
  
  before_filter :require_fedora
  before_filter :require_solr
  
  def index
    #parse_search_params
    #@search_params.merge!({:owner_field=>params[:user_id]})
    @solr_result = ActiveFedora::SolrService.instance.conn.query("depositor_t:#{params[:user_id]}")
  end
end