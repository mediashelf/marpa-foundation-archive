require "marpa/marpa_pbcore_instantiation.rb"
require "marpa/marpa_dc_datastream.rb"
require "marpa/datastreams/paperclip.rb"

# A PBCore Recording Instantiation
# Capable of tracking managing an associated file in Amazon S3
# When tracking a file in Amazon S3, the literal information about how to retrieve 
# the content (S3 account id, bucket, and key) is stored in the "s3" datastream.  
# The pbCore location simply lists "Amazon S3"
class RecordingInstantiation < ActiveFedora::Base
  
  include Hydra::ModelMethods
  include S3Fedora
  include Paperclip::Glue
  extend ActiveModel::Callbacks
  
  define_model_callbacks :save, :destroy
  
  def self.validates_each(array)
    p array.inspect
  end
  
  #paperclip
  has_attached_file :uploaded,
     :storage => :s3,
     :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
     :path => "/:style/:id/:filename",
     :s3_permissions => :private
     
  def authenticated_s3_get_url(options={})
   options.reverse_merge! :expires_in => 180.minutes
   AWS::S3::S3Object.url_for uploaded.path, uploaded.bucket_name, options
  end
  
  before_save :set_s3_metadata
  
  def set_s3_metadata
    # if uploaded.file? && uploaded.dirty?
    #   datastreams["s3"].key_values = uploaded.path
    #   datastreams["s3"].bucket_values = uploaded.bucket_name
    #   extname = File.extname(uploaded.path)
    #   pid_as_filename = self.pid.gsub(":","_")
    #   if recording.document_identifier.empty?
    #     recording_identifier = recording.document_identifier
    #   else
    #     recording_identifier = recording.pid.gsub(":","_")
    #   end
    # 
    #   self.instantiation_identifier = "#{recording_identifier}/#{pid_as_filename}#{extname}"
    #   self.iana_format = uploaded.content_type
    #   self.file_size_mb = bytesToMeg(uploaded.size).round(3).to_s
    #   # duration
    #   self.location = "Amazon S3"
    # end
  end
  
  def save
    run_callbacks :save do
       super
    end
  end
  def destroy
    run_callbacks :destroy do
       self.delete
    end
  end
  
  
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
  
  delegate :uploaded_file_name, :to=>"paperclip", :unique=>true
  delegate :uploaded_content_type, :to=>"paperclip", :unique=>true
  delegate :uploaded_file_size, :to=>"paperclip", :unique=>true
  delegate :uploaded_updated_at, :to=>"paperclip", :unique=>true
  
  has_metadata :name => "descMetadata", :type => Marpa::MarpaDCDatastream 
  
  has_metadata :name=>"pbCore", :type=>Marpa::PbcoreInstantiation
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
  has_metadata :name => "paperclip", :type => Marpa::Datastreams::Paperclip
  
  # Saves the content to S3
  # This is no file_content getter method.  Currently, in order to retrieve that content, you must rely on s3_url.
  def file_content=(data)
    
    if datastreams["s3"].bucket_values.empty?
      datastreams["s3"].bucket_values = default_s3_bucket
    end
    
    if data.class == File 
      filepath = data.path
      filesize = File.size(data)
    elsif data.class == ActionDispatch::Http::UploadedFile
      filepath = data.original_filename
      filesize = data.size
    else 
      raise TypeError, "RecordingInstantiation doesn't know how to handle #{data.class} objects"
    end
    
    extname = File.extname(filepath)
    pid_as_filename = self.pid.gsub(":","_")
    if recording.document_identifier.empty?
      recording_identifier = recording.document_identifier
    else
      recording_identifier = recording.pid.gsub(":","_")
    end
    
    basename = File.basename(filepath)
    self.instantiation_identifier = "#{recording_identifier}/#{pid_as_filename}#{extname}"
    self.iana_format = mime_type(basename)
    self.file_size_mb = bytesToMeg(filesize).round(3).to_s
    # duration
    self.location = "Amazon S3"
    

    
    datastreams["s3"].key_values = "#{recording_identifier}/#{pid_as_filename}#{extname}"

    store(data)
    self.save
  end
  
  def self.workflow_statuses
    [
      ["Collected", "collected"],
      ["Post-Production", "postProduction"],
      ["Dissemination", "dissemination"]
    ]
  end
  
  private
  
  # Return the mimeType for a given file name
  # @param [String] file_name The filename to use to get the mimeType
  # @return [String] mimeType for filename passed in. Default: application/octet-stream if mimeType cannot be determined
  def mime_type file_name
    mime_types = MIME::Types.of(file_name)
    mime_type = mime_types.empty? ? "application/octet-stream" : mime_types.first.content_type
  end
  
  MEGABYTE = 1024.0 * 1024.0
  def bytesToMeg bytes
    bytes /  MEGABYTE
  end
  
  
end