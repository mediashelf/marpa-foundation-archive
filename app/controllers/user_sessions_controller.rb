class UserSessionsController < ApplicationController
   #
   # PubCookie will only be used to trigger the authentication server once.
   # After the user succesfully logs in, PubCookie will redirect back to the "new" action here.
   # Once we get the REMOTE_USER value from PubCookie (Apache)
   # we set our own session value and never bother with PubCookie again.
   #
   # In production, for the :80 section of the configs, Apache should be set up to do a 
   # redirect for /login and /logout to an SSL request.  Also, for the :443 section of the
   # configs, /login and /logout should be set up to turn on and off NetBadge authentication.
   # If these steps aren't in place, a temp account will be created
   #
   ### Example for the :80 section 
   # RewriteEngine On
   # RewriteLog  "/var/log/httpd/hydrangea_rewrite_log"
   # RewriteLogLevel 2
   # RewriteCond %{HTTPS} !=on
   # RewriteRule ^/login https://%{HTTP_HOST}/login [R=301,L]
   # RewriteRule ^/logout https://%{HTTP_HOST}/logout [R=301,L]
   ### Example for the :443 section
   # <Location /login>
   #   AuthType NetBadge
   #   require valid-user
   #   PubcookieAppId hydrangea
   #   PubcookieInactiveExpire -1
   # </Location>
   # <Location /logout>
   #   PubcookieEndSession on
   # </Location>
   
   def new
     # if the session is already set, use the session login
       if session[:login]
         user = User.find_by_login(session[:login])
       # request coming from PubCookie... get login from REMOTE_USER
       elsif request.env['REMOTE_USER']
         user = User.find_or_create_by_login(request.env['REMOTE_USER']) if user.nil?
       else
         # Create the temp/demo user if the above methods didn't work
         user = User.create(:login=>'demo_' + User.count.to_s) if user.nil?
       end
       # store the user_id in the session
       session[:login] = user.login
       @user_session = UserSession.create(user, true)

       # redirect to the catalog with http protocol
       # make sure there is a session[:search] hash, if not just use an empty hash
       # and merge in the :protocol key
       redirect_params = (session[:search] || {}).merge(:protocol=>'http')
       redirect_to root_url(redirect_params)
   end
   
   def destroy
      reset_session
      session[:login] = nil
      current_user_session.destroy if current_user_session
      redirect_params = (session[:search] || {}).merge(:protocol=>'http')
      redirect_to logged_out_url(redirect_params)
    end
    
  def logged_out
  end

end
