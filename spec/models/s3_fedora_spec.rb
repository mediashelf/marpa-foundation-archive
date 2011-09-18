require File.join( File.dirname(__FILE__), "../spec_helper" )
require 'aws/s3'

describe S3Fedora do
  before(:all) do
    class S3FedoraTest < ActiveFedora::Base
      include S3Fedora
    end
  end
  
  before(:each) do
    @s3fedora = S3FedoraTest.new
    @file = fixture("YogurtMeow.mp3")
  end
  
  describe "store" do
    it "should store the given data in S3 using the bucket & key info from the s3 datastream" do
      s3_ds = @s3fedora.datastreams["s3"]
      s3_ds.bucket_values = "presetbucket"
      s3_ds.key_values = "foo/bar.mp3"
      AWS::S3::S3Object.expects(:store).with("foo/bar.mp3", @file, "presetbucket")
      @s3fedora.store(@file)
    end
  end
  
end

