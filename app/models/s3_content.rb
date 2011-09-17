require 'aws/s3'

class S3Content < ActiveFedora::Base
  
  include Hydra::ModelMethods
  
  has_metadata :name => "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream do |m|
    m.field :import_id, :symbol, :xml_node=>'identifier', :element_attrs=>{:type=>'import'}
  end
  
  has_metadata :name => "s3", :type => ActiveFedora::MetadataDatastream do |m|
    m.field "key", :symbol
    m.field "bucket", :symbol
    m.field "account_id", :symbol
  end  
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
  def label=(label)
    super
    datastreams_in_memory["descMetadata"].title_values = label
  end    
  
  # Returns an authorized S3 url for the corresponding S3 content
  # The url authorization expires afte 1.5 hours.
  def s3_url
    establish_s3_connection
    bucket = self.datastreams["s3"].bucket_values.first
    key = self.datastreams["s3"].key_values.first
    AWS::S3::S3Object.url_for(key, bucket, :expires_in => 60 * 60 * 1.5)
  end
  
  def store(data,filename=nil,bucket="uploads")
    s3_ds = datastreams["s3"]
    if s3_ds.bucket_values.empty?
      s3_ds.bucket_values = bucket
    end
    if s3_ds.key_values.empty?
      s3_ds.key_values = filename
    end    
    bucket = s3_ds.bucket_values.first
    key = s3_ds.key_values.first
    establish_s3_connection

    S3Object.store(key, data, bucket)
  end
  
  def establish_s3_connection
    # Set up the connection to S3 if it has not already been established
    s3keys = YAML.load(File.open(File.join(RAILS_ROOT,"config","s3.yml")))
    account_id = self.datastreams["s3"].account_id_values.first
    
    # if s3keys.has_key?(account_id)
    #   begin
    #     AWS::S3::Base.establish_connection!(
    #       :access_key_id     => s3keys[account_id]["access_key_id"],
    #       :secret_access_key => s3keys[account_id]['secret_access_key']
    #     )
    #   end
    # else
    #   raise StandardError, "There is no access key information for #{account_id} in config/s3.yml"
    # end
    
    begin
      AWS::S3::Base.establish_connection!(
        :access_key_id     => s3keys["default"]["access_key_id"],
        :secret_access_key => s3keys["default"]['secret_access_key']
      )
    end
  end
  
  # Eventually, this should be switched to write the content to S3...
  # def add_file_datastream(file, opts={})
  #   super
  #   datastreams_in_memory["descMetadata"].extent_values = bits_to_human_readable(File.size(file))
  # end
  
end