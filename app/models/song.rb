require 'marpa/marpa_dc_datastream'
class Song < ActiveFedora::Base
    include Hydra::ModelMethods
    include ActiveFedora::Relationships

    has_relationship "talks", :is_about_songs, :inbound=>true
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata


    delegate :english_title, :to=>'descMetadata', :unique=>true


    def initialize (attrs = {} )
      attrs ||= {}
      super(attrs)
      self.attributes=attrs
    end

    def update_attributes(properties)
      self.attributes=properties
      save
    end
    def attributes=(properties)
      if (properties[:english_title])
        self.english_title=properties[:english_title]
      end
    end
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Song")
      solr_doc
    end
end

