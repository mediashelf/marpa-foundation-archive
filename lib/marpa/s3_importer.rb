require 'aws/s3'
require "s3_content"
require "active-fedora"

class Marpa::S3Importer 
  
  attr_accessor :bucket_name, :import_directory, :account_id, :import
  
  def initialize()
    @bucket_name = 'marpa-foundation'
    @import_directory = "import"

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
    account_id = AWS::S3::Base.connection.access_key_id
  end
  
  def import(import_directory=@import_directory)
    import = load_directory(import_directory)
    process_import(import)
  end

  def load_directory(import_directory=@import_directory)
    @import_directory = import_directory
    puts "loading directory \"#{import_directory}\" from #{@bucket_name} bucket"
    @import = AWS::S3::Bucket.objects(@bucket_name, :prefix=>import_directory)
    puts "... found #{@import.size} objects in #{import_directory}"
    return @import
  end

  def process_import(import=@import)
    import.each do |obj|
     if obj.key.include?(".DS_Store") 
      puts "tempted to delete #{obj.key}"
      # obj.delete
     elsif obj.key.include?(".xls") 
      puts "skipping #{obj.key}"
     else
      puts "importing #{obj.key}"
      path = obj.key.gsub("#{import_directory}/", "")
      # fa = FileAsset.new
      # fa.add_file_datastream(:dsLocation=>obj.url)
      s3c = S3Content.new
      s3_ds = s3c.datastreams["s3"]
        s3_ds.key_values = obj.key
        # These methods work, but re-using existing variables for speed.
        # s3_ds.bucket = obj.bucket.name
        # s3_ds.account_id = AWS::S3::Base.connection.access_key_id
        s3_ds.bucket_values = @bucket_name
        s3_ds.account_id_values = @account_id
      s3c.datastreams["descMetadata"].import_id_values = path
      s3c.datastreams["rightsMetadata"].permissions({:group=>"archivist"}, "edit")
      s3c.datastreams["rightsMetadata"].permissions({:group=>"admin"}, "edit")
      s3c.save
      puts "... saved as #{s3c.pid}"
     end
    end
  end
end
