require 'aws/s3'
require "marpa/marpa_core"

class S3Instantiation < RecordingInstantiation
  
  include S3Fedora
  
end