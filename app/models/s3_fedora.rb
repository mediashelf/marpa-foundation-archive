require 'aws/s3'
module S3Fedora
  
  def self.included(klazz)
    # klazz.extend Hydra::ModelMethods
    
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
    AWS::S3::S3Object.url_for(key, bucket, :expires_in => 60 * 60 * 1.5)
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
    s3keys = YAML.load(File.open(File.join(RAILS_ROOT,"config","s3.yml")))
  
    account_id = self.datastreams["s3"].account_id_values.first
    # if self.datastreams["s3"].account_id_values.empty?
    #   raise Exception, "The S3 account id must be set on the object before you try to connect to s3."
    # end
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
  
  # Default s3 bucket for storing content
  def default_s3_bucket
    "hydra_uploads"
  end
  
  # Ensure that the bucket you want to use exists and you have permission to use it
  def ensure_bucket_exists(bucket)
    begin
      AWS::S3::Bucket.find(bucket)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(bucket)
    rescue AWS::S3::AccessDenied
      begin
        AWS::S3::Bucket.create(bucket)
      rescue AWS::S3::BucketAlreadyExists
        raise AWS::S3::AccessDenied, "The bucket you're trying to use already exists but you don't have permission to use it.  Check your ACLs"
      end
    end
  end
  
end