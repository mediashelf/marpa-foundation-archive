require "hydra"
require "marpa/marpa_core"
require "marpa/datastreams/associated_texts"

class Talk < ActiveFedora::Base

    include Hydra::ModelMethods
    include ActiveFedora::Associations, ActiveFedora::Reflection

    def initialize (attrs =nil)
      attrs ||= {}
      super(attrs.dup)
      # pid and new_object are set when you call ActiveFedora::Base.find
      [:pid, :new_object,:create_date, :modified_date].each { |k| attrs.delete(k)}
      self.attributes = attrs unless attrs.empty?
    end

    def update_attributes(properties)
      self.attributes = properties
      save
    end
  
    #has_relationship "programs", :is_part_of 
    belongs_to :program, :property=>:is_part_of
    has_relationship "file", :is_part_of, :inbound => true # has_many :files
    has_relationship "manifestation", :is_description_of

    #has_relationship "topics", :has_topic
    has_many :topics, :property=>:has_topic

    has_relationship "songs", :is_about_songs
    has_relationship "quotations", :is_about_quotations
    has_relationship "texts", :is_about_texts

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    has_metadata :name => "associatedTexts", :type => Marpa::Datastreams::AssociatedTexts


    delegate :english_title, :to=>'descMetadata', :unique=>true
    delegate :date, :to=>'descMetadata', :unique=>true
    delegate :duration, :to=>'descMetadata', :unique=>true
    delegate :subject, :to=>'descMetadata', :unique=>true
    delegate :note, :to=>'marpaCore', :unique=>true

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
