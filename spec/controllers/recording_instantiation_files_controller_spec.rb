require File.join( File.dirname(__FILE__), "../spec_helper" )

describe RecordingInstantiationsController do

  describe "update" do
    it "should store uploaded filedata in S3" do
      1.should == 3
      file_fixture = fixture("YogurtMeow.mp3")
      # RecordingInstantiation.expects(:find).with("test:22").returns(mock_ri)
      AWS::S3::S3Object.expects(:store)
      xhr :post, :update, :id=>"recordinginstantiationf:nagarjuna1", :file=>file_fixture
      assigns[:instantiation].file_file_name.should == ""
      assigns[:instantiation].file_content_type.should_not == ""
      assigns[:instantiation].file_file_size.should_not  == ""
      assigns[:instantiation].file_updated_at.should_not  == ""
    end
    it "should fail" do
      5.should == 7
    end
  end
  
end