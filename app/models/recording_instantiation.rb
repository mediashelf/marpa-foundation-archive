require "marpa/marpa_pbcore_instantiation.rb"
require "marpa/marpa_dc_datastream.rb"

class RecordingInstantiation < ActiveFedora::Base
  
  include Hydra::ModelMethods
  include S3Fedora
  
  belongs_to :talk, :property=>:is_part_of
  
  belongs_to :recording, :property=>:has_description
  
  
  delegate :duration, :to=>'pbCore', :unique=>true
  delegate :instantiation_identifier, :to=>'pbCore', :unique=>true
  delegate :iana_format, :to=>'pbCore', :unique=>true
  delegate :file_size_mb, :to=>'pbCore', :unique=>true
  delegate :media_type, :to=>'pbCore', :unique=>true
  delegate :location, :to=>'pbCore', :unique=>true
  delegate :informal_note, :to=>'pbCore', :unique=>true  
  delegate :technical_note, :to=>'pbCore', :unique=>true
  delegate :workflow_status, :to=>'pbCore', :unique=>true
  
  has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
  
  has_metadata :name=>"pbCore", :type=>Marpa::PbcoreInstantiation
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
  def self.workflow_statuses
    [
      ["Collected", "collected"],
      ["Post-Production", "postProduction"],
      ["Dissemination", "dissemination"]
    ]
  end
  
end