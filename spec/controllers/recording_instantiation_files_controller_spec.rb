require File.join( File.dirname(__FILE__), "../spec_helper" )

describe RecordingInstantiationFilesController do

  describe "create" do
    it "should store uploaded filedata in S3" do
      mock_file = mock("File")
      mock_ri = mock("RecordingInstantiation")
      mock_ri.expects(:file_content=).with(mock_file)
      RecordingInstantiation.expects(:find).with("test:22").returns(mock_ri)
      xhr :post, :create, :recording_instantiation_id=>"test:22", :Filedata=>[mock_file]
    end
  end
  
end