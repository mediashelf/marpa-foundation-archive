gem "ruby-fedora"
require "active_fedora"
class MarpaLecture < ActiveFedora::Base

    has_relationship "course", :is_part_of
    has_relationship "file", :is_component_of, :inbound => true
    has_relationship "manifestation", :is_description_of

    has_metadata :name => "dublin_core", :type => ActiveFedora::QualifiedDublinCoreDatastream do |m|
      # Date Recorded dc:date
      # Topics dc:subject
    end
    
    has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
      m.field "sub_topic", :string
      m.field "commentary_taught", :string 
      m.field "restriction_level", :string
      m.field "restriction_instructions", :text
      m.field "tibetan_materials", :string, :xml_node => "materials", :language => "tibetan"
      m.field "english_materials", :string, :xml_node => "materials", :language => "english"
      m.field "notes", :text
      # Location of our master file
      #number of units in original recording 
    end
    
    def file_objects_append(file_asset)
      super(file_asset)
      if relationships[:self][:is_description_of].nil?
        add_relationship(:is_description_of, file_asset)
        datastreams_in_memory["dublin_core"].title_values = file_asset.label
      end
    end
    
end
