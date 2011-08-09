require "hydra"
require "marpa/marpa_core"
require "marpa/datastreams/associated_texts"

class Talk < ActiveFedora::Base

    include Hydra::ModelMethods

    def initialize (attrs = {} )
      attrs ||= {}
      super(attrs)
      populate_attributes(attrs)
    end

    def update_attributes(properties)
      populate_attributes(properties)
      save
    end
    def populate_attributes(properties)
      if (properties[:english_title])
        self.english_title=properties[:english_title]
      end
      if (properties[:date])
        self.date=properties[:date]
      end
      if (properties[:duration])
        self.duration=properties[:duration]
      end
      if (properties[:subject])
        self.subject=properties[:subject]
      end
      if (properties[:note])
        self.note=properties[:note]
      end
    end
  
    has_relationship "courses", :is_part_of
    has_relationship "file", :is_part_of, :inbound => true
    has_relationship "manifestation", :is_description_of

    has_relationship "topics", :is_topic_of, :inbound => true

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    has_metadata :name => "associatedTexts", :type => Marpa::Datastreams::AssociatedTexts


    delegate :english_title, :to=>'descMetadata'
    delegate :date, :to=>'descMetadata'
    delegate :duration, :to=>'descMetadata'
    delegate :subject, :to=>'descMetadata'
    delegate :note, :to=>'marpaCore'
    
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
