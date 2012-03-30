require 'aws/s3'
require "marpa/marpa_core"

class Recording < ActiveFedora::Base
  
  include Hydra::ModelMethods
  include ActiveFedora::Relationships
  
  belongs_to :talk, :property=>:is_part_of
  has_relationship "recording_instantiations", :has_description, :inbound=>true
  #has_many :recording_instantiations, :property=>:is_described_by 
  
  delegate :document_identifier, :to=>'marpaCore', :unique=>true
  delegate :duration, :to=>'marpaCore', :unique=>true
  delegate :originally_recorded_by, :to=>'marpaCore', :unique=>true
  delegate :contributed_by, :to=>'marpaCore', :unique=>true
  delegate :note, :to=>'marpaCore', :unique=>true
  delegate :restriction_level, :to=>'marpaCore', :unique=>true
  delegate :restriction_instructions, :to=>'marpaCore', :unique=>true
  
  delegate :physical_instance_format, :to=>'marpaCore', :unique=>true
  delegate :physical_instance_location, :to=>'marpaCore', :unique=>true
  delegate :physical_instance_notes, :to=>'marpaCore', :unique=>true
  
  
  has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
  
  has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
end
