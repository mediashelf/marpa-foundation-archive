require 'aws/s3'
module S3Fedora
  
  def self.included(klazz)
    
    metadata_definition_proc = Proc.new do |m| 
      m.field "key", :symbol
      m.field "bucket", :symbol
      m.field "account_id", :symbol
    end
    klazz.send(:has_metadata, :name => "s3", :type => ActiveFedora::MetadataDatastream, &metadata_definition_proc)
  end
  
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
    s3 = AWS::S3.new
    s3.buckets[bucket].objects[key].url_for(:read, :expires => 60 * 60 * 1.5)
  end
  
  # Store the given data in S3
  # @param data
  # @param filename
  # @param bucket
  def store(data)
    s3_ds = datastreams["s3"]
    
    if s3_ds.bucket_values.empty? 
      raise Exception, "The S3 bucket must be set before you try to store content."
    elsif s3_ds.key_values.empty?
      raise Exception, "The S3 key must be set before you try to store content."
    else
      bucket = s3_ds.bucket_values.first
      key = s3_ds.key_values.first
    end
    
    establish_s3_connection
    ensure_bucket_exists(bucket)
    
    if data.respond_to?(:open)
      AWS::S3::S3Object.store(key, data.open, bucket)
    else
      AWS::S3::S3Object.store(key, data, bucket)
    end
  end
  
  def establish_s3_connection
    # Set up the connection to S3 if it has not already been established
    s3keys = YAML.load(File.open(File.join(Rails.root,"config","amazon_s3.yml")))
  
    account_id = self.datastreams["s3"].account_id_values.first
    
    begin
      AWS.config(
        :access_key_id     => s3keys[Rails.env]["access_key_id"],
        :secret_access_key => s3keys[Rails.env]['secret_access_key']
      )
    end
  end
  
  # Default s3 bucket for storing content
  def default_s3_bucket
    "hydra_uploads"
  end
  
  # Ensure that the bucket you want to use exists and you have permission to use it
  def ensure_bucket_exists(bucket)
    s3 = AWS::S3.new
    unless s3.buckets.collect(&:name).include?(bucket)
      s3.buckets.create(bucket)
    end
  end
  
end
