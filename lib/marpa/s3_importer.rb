require 'aws/s3'
require "active-fedora"

class Marpa::S3Importer 
  
  attr_accessor :bucket_name, :bucket, :import_directory, :account_id, :import
  
  # Create a new S3Importer
  # Relies on config/s3.yml to provide S3 access_key_id and secret_access_key
  # @param [Hash] opts Options: :bucket_name (default: "marpa-foundation""), :import_directory (default: "import")
  def initialize(opts={})
    opts = {:bucket_name=>'marpa-foundation', :import_directory=>"import"}.merge(opts)
    @bucket_name = opts[:bucket_name]
    @import_directory = opts[:import_directory]

    # Set up the connection to S3 if it has not already been established
    s3keys = YAML.load(File.open(File.join(RAILS_ROOT,"config","s3.yml")))
    begin
      AWS::S3::Base.connection
    rescue AWS::S3::NoConnectionEstablished
      AWS::S3::Base.establish_connection!(
        :access_key_id     => s3keys["default"]["access_key_id"],
        :secret_access_key => s3keys["default"]['secret_access_key']
      )
    end
    @account_id = AWS::S3::Base.connection.access_key_id
    @bucket = AWS::S3::Bucket.find(@bucket_name)
  end
  
  def import(import_directory=@import_directory)
    import = load_directory(import_directory)
    report
    populate_fedora(import)
  end

  def load_directory(import_directory=@import_directory)
    @import_directory = import_directory
    puts "loading directory \"#{import_directory}\" from #{@bucket_name} bucket"
    @import = AWS::S3::Bucket.objects(@bucket_name, :prefix=>import_directory)
    return @import
  end
  
  def report
    puts "... found #{@import.size} objects in #{import_directory} directory within #{@bucket_name} bucket"
  end

  def populate_fedora(import=@import)
    import.each do |obj|
     if obj.key.include?(".DS_Store") 
      puts "tempted to delete #{obj.key}"
      # obj.delete
     elsif obj.key.include?(".xls") 
      puts "skipping #{obj.key}"
     else
      puts "importing #{obj.key}"
      s3c = fobject_from_s3object(obj)
      s3c.save
      puts "... saved as #{s3c.pid}"
     end
    end
  end
  
  # Create a Fedora object of @model with metadata from @row
  # @param [AWS::S3::S3Object] s3o the S3 object to import
  # @return [S3Content] the Fedora S3Content object
  def fobject_from_s3object(s3object)
    s3c = S3Content.new
    s3_ds = s3c.datastreams["s3"]
      s3_ds.key_values = s3object.key
      # These methods work, but re-using existing variables for speed.
      # s3_ds.bucket = obj.bucket.name
      # s3_ds.account_id = AWS::S3::Base.connection.access_key_id
      s3_ds.bucket_values = @bucket_name
      s3_ds.account_id_values = @account_id
    path = s3object.key.gsub("#{@import_directory}/", "")
    ext = File.extname(path)
    path = path.gsub(ext, "").gsub("/", "-")
    s3c.datastreams["descMetadata"].import_id_values = path
    s3c.datastreams["rightsMetadata"].permissions({:group=>"archivist"}, "edit")
    s3c.datastreams["rightsMetadata"].permissions({:group=>"admin"}, "edit")
    return s3c
  end
  
end
