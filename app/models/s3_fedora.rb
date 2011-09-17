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