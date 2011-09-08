require 'marpa/marpa_dc_datastream'
class Topic < ActiveFedora::Base
    include Hydra::ModelMethods

    has_and_belongs_to_many :talks, :property=>:has_topic  ### Good test case for has_and_belongs_to_many
    has_and_belongs_to_many :programs, :property=>:has_topic  ### Good test case for has_and_belongs_to_many
    #has_relationship "talks", :has_topic, :inbound => true
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata


    delegate :english_title, :to=>'descMetadata', :unique=>true


    def initialize (attrs = {} )
      attrs ||= {}
      super(attrs.dup)
      # pid and new_object are set when you call ActiveFedora::Base.find
      [:pid, :new_object,:create_date, :modified_date].each { |k| attrs.delete(k)}
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
