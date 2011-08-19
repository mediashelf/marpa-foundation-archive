require 'marpa/datastreams/associated_text'
class ProgramText < ActiveFedora::Base

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
  
    belongs_to :program, :property=>:is_studied_by
    belongs_to :text, :property=>:is_object_of_study
    has_metadata :name => "descMetadata", :type => Marpa::Datastreams::AssociatedText

    delegate :nature, :to =>'descMetadata', :unique=>true
    delegate :chapter, :to =>'descMetadata', :unique=>true
    delegate :pages, :to =>'descMetadata', :unique=>true
    delegate :sections, :to =>'descMetadata', :unique=>true

    def id   ### Needed for the nested form helper
      self.pid
    end

end

