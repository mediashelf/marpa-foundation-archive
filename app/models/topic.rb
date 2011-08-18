require 'marpa/marpa_dc_datastream'
class Topic < ActiveFedora::Base
    include Hydra::ModelMethods

    has_relationship "talks", :has_topic, :inbound => true
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata


    delegate :english_title, :to=>'descMetadata', :unique=>true


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
    end
end
