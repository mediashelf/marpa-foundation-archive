Given /^I am logged in as "([^\"]*)"$/ do |login|
  email = "#{login}@#{login}.com"
  user = User.create(:login => login, :email => email, :password => "password", :password_confirmation => "password")
  visit user_sessions_path(:user_session => {:login => login, :password => "password"}), :post
  User.find(user.id).should_not be_nil
end

Given /^I am a superuser$/ do
  login = "BigWig"
  email = "bigwig@bigwig.com"
  user = User.create(:id => 10, :login => login, :email => email, :password => "password", :password_confirmation => "password")
  user.superuser = Superuser.create(:id => 20, :user_id => 10)
  visit user_sessions_path(:user_session => {:login => login, :password => "password"}), :post
  visit superuser_path
end