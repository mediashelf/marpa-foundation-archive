require "hydra"
require "marpa/marpa_core"

#TODO rename to program
class MarpaCourse < ActiveFedora::Base
    include Hydra::ModelMethods

    ##TODO rename to talks
    has_relationship "lectures", :is_part_of, :inbound => true
    has_relationship "place", :is_location_of
    
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    delegate :title, :to=>'descMetadata'
    delegate :creator, :to=>'descMetadata'
    
    def file_objects_append(file_asset)
      lecture = Talk.new
      lecture.file_objects_append(file_asset)
      lecture.add_relationship(:is_part_of, self)
      lecture.save
      lecture
    end
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Course")

      solr_doc
    end

end
