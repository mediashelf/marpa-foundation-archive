require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'mocha'

describe LdapPersonPhotosController do
  
  before do
    #controller.stubs(:protect_from_forgery).returns("meh")
    session[:user]='bob'
  end
  
  it "should use LdapPersonPhotosController" do
    controller.should be_an_instance_of(LdapPersonPhotosController)
  end
  
  it "should be restful" do
    route_for(:controller=>'ldap_person_photos', :action=>'show', :id=>"_PID_").should == '/catalog/_PID_/ldap_photo'
    params_from(:get, '/catalog/_PID_/ldap_photo').should == {:controller=>'ldap_person_photos', :id=>"_PID_", :action=>'show'}
  end
end