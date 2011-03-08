require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


# See cucumber tests (ie. /features/edit_document.feature) for more tests, including ones that test the edit method & view
# You can run the cucumber tests with 
#
# cucumber --tags @edit
# or
# rake cucumber

describe AssetsController do
  
  before do
    request.env['WEBAUTH_USER']='bob'
  end
  
  it "should use DocumentController" do
    controller.should be_an_instance_of(AssetsController)
  end
  
  describe "update" do
    it "should update the object with the attributes provided" do
      mock_document = mock("document")
      mock_document.stubs(:update_from_computing_id).returns(nil)
      HydrangeaArticle.expects(:find).with("_PID_").returns(mock_document)
      
      simple_request_params = {"asset"=>{
          "descMetadata"=>{
            "subject"=>{"0"=>"subject1", "1"=>"subject2", "2"=>"subject3"}
          }
        }
      }
      
      mock_document.expects(:update_indexed_attributes).with({"subject"=>{"0"=>"subject1", "1"=>"subject2", "2"=>"subject3"}}, {:datastreams=>"descMetadata"}).returns({"subject"=>{"2"=>"My Topic"}})
      mock_document.expects(:save)
      controller.stubs(:display_release_status_notice)
      # put :update, :id=>"_PID_", "asset"=>{"subject"=>{"-1"=>"My Topic"}}
      put :update, {:id=>"_PID_"}.merge(simple_request_params)
    end
    
    it "should support updating OM::XML datastreams" do
      mock_document = mock("document")
      mock_document.stubs(:update_from_computing_id).returns(nil)
      # content_type is specified as hydrangea_dataset.  If not specified, it defaults to HydrangeaArticle
      HydrangeaDataset.expects(:find).with("_PID_").returns(mock_document)
      
      update_method_args = [ { [{:person=>0}, :role] => {"0"=>"role1","1"=>"role2","2"=>"role3"} }, {:datastreams=>"descMetadata"} ]
      mock_document.expects(:update_indexed_attributes).with( *update_method_args ).returns({"person_0_role"=>{"0"=>"role1","1"=>"role2","2"=>"role3"}})
      mock_document.expects(:save)
      
      
      nokogiri_request_params = {
        "id"=>"_PID_", 
        "content_type"=>"hydrangea_dataset",
        "field_selectors"=>{
          "descMetadata"=>{
            "person_0_role"=>[{":person"=>"0"}, "role"]
          }
        }, 
        "asset"=>{
          "descMetadata"=>{
            "person_0_role"=>{"0"=>"role1", "1"=>"role2", "2"=>"role3"}
          }
        }
      }
      controller.stubs(:display_release_status_notice)
      put :update, nokogiri_request_params
      # put :update, :id=>"_PID_", "content_type"=>"hydrangea_article", "datastream"=>"descMetadata", "field_name"=>"person_0_last_name","parent_select"=>[{":person"=>"0"}, ":last_name"], "child_index"=>"0", "value"=>"Sample New Value"
    end
    
    it "should initialize solr" do
      pending
      ActiveFedora::SolrService.expects(:register)
      SaltDocument.expects(:find).with("_PID_").returns(stub_everything)
      put :update, :id=>"_PID_", "asset"=>{"subject"=>{"-1"=>"My Topic"}}
      session[:user].should == 'bob'
    end
  end
  
  describe "destroy" do
    it "should delete the asset identified by pid" do
      mock_obj = mock("asset", :delete)
      mock_obj.expects(:destroy_child_assets).returns([])
      ActiveFedora::Base.expects(:load_instance_from_solr).with("__PID__").returns(mock_obj)
      ActiveFedora::ContentModel.expects(:known_models_for).with(mock_obj).returns([HydrangeaArticle])
      HydrangeaArticle.expects(:load_instance_from_solr).with("__PID__").returns(mock_obj)
      delete(:destroy, :id => "__PID__")
    end
  end
end
