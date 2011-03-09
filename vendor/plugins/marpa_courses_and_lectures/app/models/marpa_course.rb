require "hydra"
require "marpa/marpa_core"

class MarpaCourse < ActiveFedora::Base

    include Hydra::ModelMethods

    has_relationship "lectures", :is_part_of, :inbound => true
    
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    
    has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
    
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
    
    # has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    #   m.field 'collection', :string
    #   m.field 'depositor', :string
    #   m.field "sub_topic", :string
    #   m.field "commentary_taught", :string 
    #   m.field "restriction_level", :string
    #   m.field "restriction_instructions", :text
    #   m.field "tibetan_materials", :string, :xml_node => "materials", :language => "tibetan"
    #   m.field "english_materials", :string, :xml_node => "materials", :language => "english"
    #   m.field "originally_recorded_by", :string
    #   m.field "contributed_by", :string
    #   m.field "notes", :text
    #   m.field "original_filename", :text
    #   # Location of our master file
    #   #number of units in original recording 
    # end
    
    def file_objects_append(file_asset)
      lecture = Lecture.new
      lecture.file_objects_append(file_asset)
      lecture.add_relationship(:is_part_of, self)
      lecture.save
      return lecture
    end
    
end
