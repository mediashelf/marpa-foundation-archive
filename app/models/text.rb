require "hydra"

class Text < ActiveFedora::Base

    include Hydra::ModelMethods
  
    has_relationship "lecture", :is_part_of

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Text")

      solr_doc
    end
    
end

