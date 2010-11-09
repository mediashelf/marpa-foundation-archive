module HydraAccessControlsHelper
  
#  def superuser_mode?
#    session[:superuser_mode] ? true : false
#  end
  
  def editor?
    #test_permission(:edit) or superuser_mode?
    test_permission(:edit) or (current_user and current_user.is_being_superuser?(session))
  end
  
  def reader?
    #test_permission(:read) or superuser_mode?
    test_permission(:read) or (current_user and current_user.is_being_superuser?(session))
  end

end