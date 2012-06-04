require File.join( File.dirname(__FILE__), "../spec_helper" )
require 'aws/s3'

describe S3Fedora do
  before(:all) do
    class S3FedoraTest < ActiveFedora::Base
      include S3Fedora
      def key
        "test_key"
      end
    end
  end
  
  before(:each) do
    @s3fedora = S3FedoraTest.new
    @file = fixture("YogurtMeow.mp3")
  end
  
  describe "store" do
    it "should store the given data in S3 using the bucket from the config" do
      mock_object = mock("S3 object")
      mock_object.expects(:write).with(@file)
      @file.rewind
      mock_bucket = mock("Bucket", :objects=>{'test_key' => mock_object})
      stub_buckets = stub("buckets", :[] => mock_bucket, :collect=>[mock_bucket], :create=>'marpa-test-uploads')
      stub_s3 = stub("Mock S3", :buckets=>stub_buckets) 
      AWS::S3.expects(:new).returns(stub_s3).twice
      @s3fedora.store(@file)
    end
  end
  
end

