require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


# See cucumber tests (ie. /features/edit_document.feature) for more tests, including ones that test the edit method & view
# You can run the cucumber tests with 
#
# cucumber --tags @edit
# or
# rake cucumber

describe CatalogController do
  
  before do
    #request.env['WEBAUTH_USER']='bob'
  end

  describe "show" do
    it "should redirect to edit view if session is in edit context and user has edit permission" do
      controller.expects(:reader?).returns(true)
      controller.expects(:editor?).returns(true)
      controller.session[:viewing_context] = "edit"
      get(:show, {:id=>"marpa:1"})
      response.should redirect_to(:action => 'edit')
    end
    it "should allow you to reset the session context to browse using :viewing_context param" do
      controller.expects(:reader?).returns(true)
      controller.session[:viewing_context] = "edit"
      get(:show, :id=>"marpa:1", :viewing_context=>"browse")
      session[:viewing_context].should == "browse"
      response.should_not redirect_to(:action => 'edit')
    end
    
    it "should quietly switch session state to browse if user does not have edit permissions" do
      controller.expects(:reader?).returns(true)
      controller.expects(:editor?).returns(false)
      controller.session[:viewing_context] = "edit"
      get(:show, {:id=>"marpa:1"})
      session[:viewing_context].should == "browse"
      response.should_not redirect_to(:action => 'edit')
    end
  end
  
  describe "edit" do
    it "should enforce edit permissions, redirecting to show action and resetting session context if user does not have edit permissions" do
      mock_user = mock("User")
      mock_user.stubs(:login).returns("patron1@example.com")
      mock_user.stubs(:is_being_superuser?).returns(false)
      controller.stubs(:current_user).returns(mock_user)
      
      get :edit, :id=>"marpa:1"
      response.should redirect_to(:action => 'show')
      flash[:notice].should == "You do not have sufficient privileges to edit this document. You have been redirected to the read-only view."
    end
    it "should render normally if user has edit permissions" do
      mock_user = stub("User", :login=>"archivist@example.com")
      controller.stubs(:current_user).returns(mock_user)
      
      get :edit, :id=>"marpa:1"
      response.should_not redirect_to(:action => 'show')
    end
  end
  
end
