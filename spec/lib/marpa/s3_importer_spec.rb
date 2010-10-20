require File.expand_path( File.join( File.dirname(__FILE__), '..','..','spec_helper') )

describe Marpa::S3Importer  do

  before(:all) do
    @test_importer = Marpa::S3Importer.new
    @import = @test_importer.load_directory
    @test_importer.report
    @bucket = @test_importer.bucket
    @file1 = @bucket["import/51.mental.factors-bouddha-1988-psc-t-1c/1.mp3"]
  end
  
  describe "fobject_from_s3object" do
    it "should create an S3Content object with key, bucket & account id " do
      s3c = @test_importer.fobject_from_s3object(@file1)
      s3c.should be_kind_of(S3Content)
      
      s3_ds = s3c.datastreams["s3"]
      s3_ds.key_values.should == [@file1.key]
      s3_ds.bucket_values.should == [@test_importer.bucket_name]
      s3_ds.account_id_values.should == [@test_importer.account_id]
      
      s3c.datastreams["descMetadata"].import_id_values.should == ["51.mental.factors-bouddha-1988-psc-t-1c-1"]
    end
    it "should set permissions on the resulting S3Content object" do
      s3c = @test_importer.fobject_from_s3object(@file1)
      s3c.datastreams["rightsMetadata"].permissions({:group=>"archivist"}).should == "edit"
      s3c.datastreams["rightsMetadata"].permissions({:group=>"admin"}).should == "edit"
    end
  end
  
end