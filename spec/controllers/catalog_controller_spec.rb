require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'mocha'

# See cucumber tests (ie. /features/edit_document.feature) for more tests, including ones that test the edit method & view
# You can run the cucumber tests with 
#
# cucumber --tags @edit
# or
# rake cucumber

describe CatalogController do
  
  before do
    #controller.stubs(:protect_from_forgery).returns("meh")
    session[:user]='bob'
  end
  
  it "should use CatalogController" do
    controller.should be_an_instance_of(CatalogController)
  end

  it "should have the editor? method defined" do
   controller.should respond_to(:editor?)
  end
  
  describe "Paths Generated by Custom Routes:" do
    # paths generated by custom routes
    it "should map {:controller=>'catalog', :action=>'index'} to GET /catalog" do
      { :get => "/catalog" }.should route_to(:controller => 'catalog', :action => 'index')
    end
    it "should map {:controller=>'catalog', :action=>'show', :id=>'test:3'} to GET /catalog/test:3" do
      { :get => "/catalog/test:3" }.should route_to(:controller => 'catalog', :action => 'show', :id=>'test:3')
    end
    it "should map {:controller=>'catalog', :action=>'edit', :id=>'test:3'} to GET /catalog/test:3" do
      { :get => "/catalog/test:3/edit" }.should route_to(:controller => 'catalog', :action => 'edit', :id=>'test:3')
    end

    it "should map catalog_path" do
      # catalog_path.should == '/catalog'
      catalog_path("test:3").should == '/catalog/test:3'
    end
  end

  
  describe "filters" do
    describe "index" do
      it "should trigger enforce_index_permissions" do
        controller.expects(:add_access_controls_to_solr_params)
        controller.expects(:enforce_index_permissions)
        get :index
      end
    end
    describe "show" do
      it "should trigger enforce_show_permissions and load_fedora_document" do
        controller.expects(:load_fedora_document)
        controller.expects(:enforce_show_permissions)
        get :show, :id=>'test:3'
      end
    end
    describe "edit" do
      it "should trigger enforce_edit_permissions and load_fedora_document" do
        controller.expects(:load_fedora_document)
        controller.expects(:enforce_edit_permissions)
        get :edit, :id=>'test:3'
      end
    end
  end

  
  
end
