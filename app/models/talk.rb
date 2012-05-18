require "hydra"
require "marpa/marpa_core"

class Talk < ActiveFedora::Base
    include Hydra::ModelMethods
    include ActiveFedora::Relationships

    belongs_to :program, :property=>:is_part_of
    has_relationship "disseminations", :is_part_of, :inbound => true, :solr_fq=>"workflow_status_t:dissemination"
    #has_many :disseminations, :property=>:is_part_of

    has_relationship "recordings", :is_part_of, :inbound => true, :solr_fq=>"has_model_s:info\\:fedora/afmodel\\:Recording"
    #has_many :recordings, :property=>:is_part_of

    has_relationship "manifestation", :is_description_of

    has_and_belongs_to_many :topics, :property=>:has_topic

    has_relationship "songs", :is_about_songs
    has_relationship "quotations", :is_about_quotations
    has_many :talk_texts, :property=>:is_about_texts
    accepts_nested_attributes_for :talk_texts
    

    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata 

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
      topics.each do |topic|
        ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "topic_facet", topic.english_title)
      end
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "date_facet", date)
      
      solr_doc
    end
    
end
