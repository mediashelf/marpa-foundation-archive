require_dependency 'vendor/plugins/blacklight/app/models/user.rb'

class User < ActiveRecord::Base

  has_one :superuser
    
  def can_be_superuser?
    self.superuser ? true : false
  end
  
  def is_being_superuser?(session)
    session[:superuser_mode] ? true : false
  end

end