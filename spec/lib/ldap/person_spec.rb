require File.expand_path( File.join( File.dirname(__FILE__), '..','..','spec_helper') )

describe Ldap::Person do
  class FakeLdapWithoutPicture < Ldap::Person
    def do_ldap_lookup(computing_id)
      @ldap_vals = { LDAP_COMPUTING_ID.to_sym => ['mst3k'], LDAP_FIRST_NAME.to_sym => ['Joe'], LDAP_LAST_NAME.to_sym => ['User'], LDAP_DEPARTMENT.to_sym => ['Curry School of Education'] }
    end
  end
  
  class FakeLdapWithPicture < Ldap::Person
    def do_ldap_lookup(computing_id)
      @ldap_vals = { LDAP_FIRST_NAME.to_sym => ['Bozo'], LDAP_PHOTO.to_sym => ['fake_photo'] }
    end
  end
  
  before(:each) do
    @person = FakeLdapWithoutPicture.new("person_without_picture")
  end
  
  it "should return the first name" do
    @person.first_name.should == "Joe"
  end
  it "should return the last name" do
    @person.last_name.should == "User"
  end
  it "should return the computing id" do
    @person.computing_id.should == "mst3k"
  end
  it "should return the institution" do
    @person.institution.should == ""
  end
  it "should return the department" do
    @person.department.should == "Curry School of Education"
  end
  it "should know if there is no photo" do
    @person.has_photo?.should be_false
  end
  it "should know if there is a photo" do
    person2 = FakeLdapWithPicture.new("someone")
    person2.has_photo?.should be_true
  end
    
end