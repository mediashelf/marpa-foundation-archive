require "hydra"
require "marpa/marpa_core"

class Text < ActiveFedora::Base

    include Hydra::ModelMethods
    include ActiveFedora::Relationships
  
    has_relationship "talks", :is_part_of
    belongs_to :author, :property=>:is_author_of
    has_many :program_texts, :property=>:is_object_of_study

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata 

    delegate :english_title, :to=>'descMetadata', :unique=>true
    delegate :tibetan_title, :to=>'descMetadata', :unique=>true
    delegate :wylie_title, :to=>'descMetadata', :unique=>true
    delegate :marpa_transliteration_title, :to=>'descMetadata', :unique=>true
    delegate :sanskrit_title, :to=>'descMetadata', :unique=>true
    delegate :sanskrit_diacrit_title, :to=>'descMetadata', :unique=>true
            
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Text")

      solr_doc
    end

    def initialize (attrs = {} )
      attrs ||= {}
      super(attrs)
      populate_attributes(attrs)
    end

    # def update_attributes(properties)
    #   populate_attributes(properties)
    #   save
    # end
    def populate_attributes(properties)
      if (properties[:english_title])
        self.english_title=properties[:english_title]
      end
    end

    
end

