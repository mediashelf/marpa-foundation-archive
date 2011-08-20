require "hydra"
require "marpa/marpa_core"

class Program < ActiveFedora::Base
    include Hydra::ModelMethods

    has_many :talks, :property=>:is_part_of
    belongs_to :place, :property=>:has_location

    has_many :program_texts, :property=>:is_studied_by
    
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    delegate :title, :to=>'descMetadata', :unique=>true
    delegate :creator, :to=>'descMetadata', :unique=>true
    delegate :language, :to=>'descMetadata'
    delegate :start_date, :to=>'descMetadata', :unique=>true
    delegate :end_date, :to=>'descMetadata', :unique=>true

    accepts_nested_attributes_for :program_texts
    
    def file_objects_append(file_asset)
      lecture = Talk.new
      lecture.file_objects_append(file_asset)
      lecture.add_relationship(:is_part_of, self)
      lecture.save
      lecture
    end
    
    def to_solr(solr_doc=Hash.new, opts={})
      super(solr_doc)
      
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "object_type_facet", "Program")

      solr_doc
    end


    def attributes=(properties)
      super
      if (properties[:language])
        if RUBY_VERSION > '1.9.0'
          self.language=properties[:language].select{|k, v| v == "1"}.keys
        else 
          self.language=properties[:language].select{|k, v| v == "1"}.map {|e| e.first}
        end
      end
    end


    # Returns true if the specified +attribute+ has been set by the user or by a database load and is neither
    # nil nor empty? (the latter only applies to objects that respond to empty?, most notably Strings).
    def attribute_present?(attribute)
      value = read_attribute(attribute)
      !value.blank?
    end

    # def program_texts_attributes=(attributes)
    #   assign_nested_attributes_for_collection_association(:program_texts, attributes)
    #   ## in lieu of autosave_association_callbacks just save all of em.
    #   send(:program_texts).each {|obj| obj.save}
    # end

    # def nested_attributes_options
    #   {:program_texts=>{:allow_destroy=>true}}
    # end


end
