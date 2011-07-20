require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
  describe "The application helper" do
    it "should return the application name" do
      application_name.should == "Marpa Foundation Archive"
    end
  end
  
end
