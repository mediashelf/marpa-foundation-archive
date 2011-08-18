require "hydra"
require "marpa/marpa_core"

class Program < ActiveFedora::Base
    include Hydra::ModelMethods

    has_many :talks, :property=>:is_part_of
    #has_relationship "talks", :is_part_of, :inbound => true # has_many
    has_relationship "place", :is_location_of  ## Belongs_to 
    
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 

    delegate :title, :to=>'descMetadata'
    delegate :creator, :to=>'descMetadata'
    delegate :language, :to=>'descMetadata'
    delegate :start_date, :to=>'descMetadata'
    delegate :end_date, :to=>'descMetadata'
    
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
      if (properties[:language])
        self.language=properties[:language].select{|k, v| v == 1}.keys
      end
      [:title, :creator, :start_date, :end_date].each do |k|
        self.send(k.to_s+'=', properties[k]) if (properties[k]) 
      end
      if (properties[:place])
        self.place_ids = [properties[:place]]
      end
    end

    def place_ids=(args)
        rels = relationships[:self][:is_location_of]
        if rels
          rels.dup.each do |rel|
            remove_relationship(:is_location_of, rel)
          end
        end
        args.each do |pid|
          remote = Place.find(pid) 
          raise "Couldn't find #{pid}. Persist it first" if remote.nil?
          places_append remote 
        end
    end
    def place_ids
      self.places_ids
    end


    ## Required by associations
    def new_record?
      self.new_object?
    end


    # Returns true if the specified +attribute+ has been set by the user or by a database load and is neither
    # nil nor empty? (the latter only applies to objects that respond to empty?, most notably Strings).
    def attribute_present?(attribute)
      value = read_attribute(attribute)
      !value.blank?
    end



end
