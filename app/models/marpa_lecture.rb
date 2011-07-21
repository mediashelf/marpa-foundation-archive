require "hydra"
require "marpa/marpa_core"
require "marpa/datastreams/associated_texts"

class MarpaLecture < ActiveFedora::Base

    include Hydra::ModelMethods
  
    has_relationship "course", :is_part_of
    has_relationship "file", :is_part_of, :inbound => true
    has_relationship "manifestation", :is_description_of

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    has_metadata :name => "associatedTexts", :type => Marpa::Datastreams::AssociatedTexts
    
    def file_objects_append(file_asset)
      super(file_asset)
      if relationships[:self][:is_description_of].nil?
        add_relationship(:is_description_of, file_asset)
        datastreams_in_memory["dublin_core"].title_values = file_asset.label
      end
    end
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Talk")

      solr_doc
    end
    
end
