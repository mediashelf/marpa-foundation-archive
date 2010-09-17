# if you would like to see solr startup messages on STDERR
# when starting solr test server during functional tests use:
# 
#    rake SOLR_CONSOLE=true
#require 'hydra/testing_server'
#require "#{Rails.root}/vendor/plugins/hydra_repository/lib/mediashelf/active_fedora_helper.rb"
#require "#{Rails.root}/vendor/plugins/hydra_repository/lib/hydra.rb"
#require "#{Rails.root}/vendor/plugins/hydra_repository/lib/hydra/testing_server.rb"

JETTY_PARAMS = {
  :quiet => ENV['HYDRA_CONSOLE'] ? false : true,
  :jetty_home => ENV['HYDRA_JETTY_HOME'],
  :jetty_port => 8983,
  :solr_home => ENV['HYDRA_SOLR_HOME'],
  :fedora_home => ENV['HYDRA_SOLR_HOME']
}

#:jetty_port => ENV['HYDRA_JETTY_PORT'],
namespace :hydra do
  namespace :jetty do
    desc "Starts the bundled Hydra Testing Server"
    task :start => [:environment] do
      Hydra::TestingServer.configure(JETTY_PARAMS)
      Hydra::TestingServer.instance.start
    end
    
    desc "Stops the bundled Hydra Testing Server"
    task :stop => [:environment] do
      Hydra::TestingServer.instance.stop
    end
    
    desc "Restarts the bundled Hydra Testing Server"
    task :restart => [:environment] do
      Hydra::TestingServer.instance.stop
      Hydra::TestingServer.configure(JETTY_PARAMS)
      Hydra::TestingServer.instance.start
    end

    desc "Copies the default SOLR config for the bundled Hydra Testing Server"
    task :config do
      FileList['solr/conf/*'].each do |f|  
        cp("#{f}", 'jetty/solr/development-core/conf/', :verbose => true)
        cp("#{f}", 'jetty/solr/test-core/conf/', :verbose => true)
      end
    end

    desc "Copies the default SOLR config files and starts up the fedora instance."
    task :load => [:config, :start]

    desc "Returns the status of the Hydra::TestingServer."
    task :status => [:environment] do
      status = Hydra::TestingServer.instance.pid ? "Running: #{Hydra::TestingServer.instance.pid}" : "Not running"
      puts status
    end
  end
end
