require 'marpa/marpa_dc_datastream'
class Topic < ActiveFedora::Base
    include Hydra::ModelMethods

    has_and_belongs_to_many :talks, :property=>:is_topic_of, :inverse_of=>:has_topic  ### Good test case for has_and_belongs_to_many
    has_and_belongs_to_many :programs, :property=>:is_topic_of, :inverse_of=>:has_topic  ### Good test case for has_and_belongs_to_many
    has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
    has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata


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
