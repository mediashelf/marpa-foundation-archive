# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog
  # Extend Blacklight::Catalog with Hydra behaviors (primarily editing).
  include Hydra::Catalog

  # These before_filters apply the hydra access controls
  before_filter :enforce_access_controls
  before_filter :enforce_viewing_context_for_show_requests, :only=>:show
  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params
  CatalogController.solr_search_params_logic << :exclude_unwanted_models_from_search_results

  # A really hacky solr search params logic method
  # Will only work if the solr_parameters[:q] contains " AND NOT _query_:\"info\\\\:fedora/afmodel\\\\:FileAsset\""
  # Inserts filters into the query immediately before that string based on the list of models in #{unwanted_models}
  def exclude_unwanted_models_from_search_results(solr_parameters, user_parameters)
    q = ""
    unwanted_models.each do |m|
      if m.kind_of?(String)
        model_uri = m
      else
        model_pid = ActiveFedora::ContentModel.pid_from_ruby_class(m)
        model_uri = "info:fedora/#{model_pid}"
      end
      escaped_model_uri = model_uri.gsub(/(:)/, '\\\\\\:')
      q << " AND NOT _query_:\"#{escaped_model_uri}\""
    end
    insert_after = "{!dismax qf=$qf_dismax pf=$pf_dismax}"
    insert_before = " AND NOT _query_:\"info\\\\:fedora/afmodel\\\\:FileAsset\""
    i = solr_parameters[:q].index(insert_before)
    solr_parameters[:q].insert(i, q)
  end
  
  def unwanted_models
    return [Recording, RecordingInstantiation, Topic, ProgramText, Translator, Place, Text, Song, Quotation, TalkText, "info:fedora/afmodel:MarpaCourse"]
  end

end 
