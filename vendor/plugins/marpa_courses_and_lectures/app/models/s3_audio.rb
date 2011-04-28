class S3Audio < ActiveFedora::Base
  
  include S3Fedora
  
  has_metadata :name => "descMetadata", :type => ActiveFedora::QualifiedDublinCoreDatastream do |m|
    m.field :import_id, :symbol, :xml_node=>'identifier', :element_attrs=>{:type=>'import'}
  end
  
  has_metadata :name => "s3", :type => ActiveFedora::MetadataDatastream do |m|
    m.field "key", :symbol
    m.field "bucket", :symbol
    m.field "account_id", :symbol
  end  
  
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata
  
end