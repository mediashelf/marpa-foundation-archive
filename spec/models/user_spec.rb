require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  it "should know if a user can be a superuser" do
    user = User.create(:id => 10, :login => "BigWig")
    user.superuser = Superuser.create(:id => 20, :user_id => 10)
    user.can_be_superuser?.should be_true
  end
  
  it "should know if a user shouldn't be a superuser" do
    user = User.create(:id => 30, :login => "JoeUser")
    user.can_be_superuser?.should be_false
  end
  
  it "should know if the user is being a superuser" do
    user = User.create(:id => 40, :login => "BigWig")
    session = { :superuser_mode => true }
    user.is_being_superuser?(session).should be_true
  end

  it "should not let a non-superuser be a superuser" do
    user = User.create(:id => 50, :login => "JoeUser")
    session = {}
    user.is_being_superuser?(session).should be_false
  end
  
  it "should know if the user is not being a superuser even if the user can be a superuser" do
    user = User.create(:id => 50)
    user.superuser = Superuser.create(:id => 60, :user_id => 50)
    user.can_be_superuser?.should be_true
    session = {}
    user.is_being_superuser?(session).should be_false
  end
  
end