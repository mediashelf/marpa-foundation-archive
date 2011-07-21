require "hydra"
require "marpa/marpa_core"

class MarpaCourse < ActiveFedora::Base

    include Hydra::ModelMethods

    has_relationship "lectures", :is_part_of, :inbound => true
    
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
    
    def file_objects_append(file_asset)
      lecture = MarpaLecture.new
      lecture.file_objects_append(file_asset)
      lecture.add_relationship(:is_part_of, self)
      lecture.save
      return lecture
    end
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Course")

      solr_doc
    end
    
end
