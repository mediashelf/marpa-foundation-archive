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
  CatalogController.solr_search_params_logic << :exclude_unwanted_models

  # This filters out objects that you want to exclude from search results.  By default it only excludes FileAssets
  # @param solr_parameters the current solr parameters
  # @param user_parameters the current user-subitted parameters
  def exclude_unwanted_models(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    unwanted_models.each do |um|
      if um.kind_of?(String)
        model_uri = um
      else
        model_uri = um.to_class_uri
      end
      solr_parameters[:fq] << "-has_model_s:\"#{model_uri}\""
    end
    solr_parameters[:fq] << "-has_model_s:\"info:fedora/afmodel:FileAsset\""
  end
  
  def unwanted_models
    return [Recording, RecordingInstantiation, Topic, ProgramText, Translator, Place, Text, Song, Quotation, TalkText, "info:fedora/afmodel:MarpaCourse"]
  end

end 
