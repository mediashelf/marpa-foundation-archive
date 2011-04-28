require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FileAssetsController do
  
    describe "create" do
      it "should create an S3Content object, apply depositor metadata, and apply any additional metadata" do
        # ActiveFedora::SolrService.stubs(:register)
        mock_file = mock("File")
        filename = "Foo File"
        mock_fa = mock("FileAsset", :save)
        S3Video.expects(:new).returns(mock_fa)
        mime_type = "application/octet-stream"
        mock_fa.expects(:add_file_datastream).with(mock_file, :label=>filename, :mimeType=>mime_type)
        mock_fa.expects(:label=).with(filename)
        mock_fa.stubs(:pid).returns("foo:pid")
        xhr :post, :create, :Filedata=>mock_file, :Filename=>filename      
      end   
    end
    
    
    
end