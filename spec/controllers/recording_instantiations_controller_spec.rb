require File.join( File.dirname(__FILE__), "../spec_helper" )

describe RecordingInstantiationsController do

  describe "update" do
    it "should store uploaded filedata in S3" do
      file_fixture = fixture("YogurtMeow.mp3")
      # RecordingInstantiation.expects(:find).with("test:22").returns(mock_ri)
      AWS::S3::S3Object.expects(:store)
      xhr :post, :update, :id=>"recordinginstantiationf:nagarjuna1", :recording_instantiation=>{:file=>file_fixture}
      assigns[:instantiation].file_file_name.should == "YogurtMeow.mp3"
      assigns[:instantiation].file_content_type.should == "audio/mpeg"
      assigns[:instantiation].file_file_size.should  == "48064"
      assigns[:instantiation].file_updated_at.should  include(Time.now.to_s[0..15])
    end
  end
  
end