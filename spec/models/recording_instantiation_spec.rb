require File.join( File.dirname(__FILE__), "../spec_helper" )

describe RecordingInstantiation do
  
  before(:each) do
    @instantiation = RecordingInstantiation.new
  end
  
  it "should include S3Fedora" do
    RecordingInstantiation.included_modules.should include(S3Fedora)
  end
  
  describe "file_content=" do
    before(:each) do
      @file = fixture("YogurtMeow.mp3")
    end
    it "should update the object metadata based on submitted data and store the content in s3 using recording id + pid" do
      # should update the pbcore metadata
      @instantiation.expects(:iana_format=).with("audio/mpeg")
      @instantiation.expects(:file_size_mb=).with("0.046")
      # @instantiation.expects(:duration=).with("")
      @instantiation.expects(:location=).with("Amazon S3")
      
      # Should also update s3 key info 
      s3_ds = @instantiation.datastreams["s3"]
      recording = mock("Recording")
      recording.expects(:document_identifier).returns("rigs.pa.drug.cu.pa-bouddha-1988-psc-te-1c-talk1").twice
      @instantiation.stubs(:recording).returns(recording)
      pid_as_filename = @instantiation.pid.gsub(":","_")
      s3_ds.expects(:key_values=).with("rigs.pa.drug.cu.pa-bouddha-1988-psc-te-1c-talk1/#{pid_as_filename}.mp3")
      
      @instantiation.expects(:store).with(@file)
      @instantiation.file_content = @file      
    end
  end
  
end
