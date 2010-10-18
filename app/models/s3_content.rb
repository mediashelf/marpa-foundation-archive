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
  
  # Eventually, this should be switched to write the content to S3...
  # def add_file_datastream(file, opts={})
  #   super
  #   datastreams_in_memory["descMetadata"].extent_values = bits_to_human_readable(File.size(file))
  # end
  
end