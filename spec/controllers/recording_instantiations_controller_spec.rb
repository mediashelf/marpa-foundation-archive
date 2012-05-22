# encoding: utf-8
require "spec_helper"

describe RecordingInstantiationsController do

  describe "update" do
    it "should store uploaded filedata in S3" do
      file_fixture = fixture("YogurtMeow.mp3")
      # RecordingInstantiation.expects(:find).with("test:22").returns(mock_ri)
      # AWS::S3::S3Object.expects(:store)
      # xhr :post, :update, :id=>"recordinginstantiationf:nagarjuna1", :recording_instantiation=>{:file=>file_fixture}
      xhr :post, :update, "utf8"=>"✓", "id"=>"recordinginstantiationf:nagarjuna1", "recording"=>"", "recording_instantiation"=>{"workflow_status"=>"collected", "duration"=>"", "location"=>"?", "iana_format"=>"audio/x-caf", "file_size_mb"=>"", "instantiation_identifier"=>"meow", "uploaded"=>file_fixture, "informal_note"=>"", "technical_note"=>""}
      assigns[:instantiation].uploaded_file_name.should == "YogurtMeow.mp3"
      assigns[:instantiation].uploaded_content_type.should == "audio/mpeg"
      assigns[:instantiation].uploaded_file_size.should  == "48064"
      assigns[:instantiation].uploaded_updated_at.should  include(Time.now.to_s[0..15])
    
      assigns[:instantiation].iana_format.should == "audio/x-caf" #"audio/mpeg"
      assigns[:instantiation].file_size_mb.should == "0.046"
      # @instantiation.expects(:duration=).with("")
      assigns[:instantiation].location.should == "Amazon S3"
      
      # Should also update s3 key info 
      # s3_ds = @instantiation.datastreams["s3"]
      # @instantiation.stubs(:recording).returns(mock("Recording", :document_identifier=>"rigs.pa.drug.cu.pa-bouddha-1988-psc-te-1c-talk1"))
      # pid_as_filename = @instantiation.pid.gsub(":","_")
      # s3_ds.expects(:key_values=).with("rigs.pa.drug.cu.pa-bouddha-1988-psc-te-1c-talk1/#{pid_as_filename}.mp3")
      
      
    end
  end
  
end
