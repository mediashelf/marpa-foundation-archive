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
    descMetadata.title_values = label
  end    
  
  # Returns an authorized S3 url for the corresponding S3 content
  # The url authorization expires afte 1.5 hours.
  def s3_url
    establish_s3_connection
    bucket = s3keys["bucket"]
    key = self.datastreams["s3"].key_values.first
    s3 = AWS::S3.new
    s3.buckets[bucket].objects[key].url_for(:read, :expires => 60 * 60 * 1.5)
  end
  
  # Store the given data in S3
  # @param data
  def store(data)
    establish_s3_connection
    bucket = s3keys["bucket"]
    ensure_bucket_exists(bucket)
    
    conn = AWS::S3.new
    obj = conn.buckets[bucket].objects[key]
    obj.write(data)
  end

  def s3keys
    @s3keys ||= YAML.load(File.open(File.join(Rails.root,"config","amazon_s3.yml")))[Rails.env]
  end
  
  def establish_s3_connection
    # Set up the connection to S3 if it has not already been established
  
    begin
      AWS.config(
        :access_key_id     => s3keys["access_key_id"],
        :secret_access_key => s3keys['secret_access_key']
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
