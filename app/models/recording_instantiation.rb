require 'aws/s3'
require "marpa/marpa_core"

class RecordingInstantiation < ActiveFedora::Base
  
  include Hydra::ModelMethods
  include S3Fedora
  
  belongs_to :talk, :property=>:is_part_of
  
  belongs_to :description_document, :property=>:is_described_by
  
  
  delegate :duration, :to=>'marpaCore', :unique=>true
  
  has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
  
  has_metadata :name=>"marpaCore", :type=>Marpa::MarpaCore
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
end