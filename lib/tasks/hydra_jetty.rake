namespace :hydra do
  namespace :jetty do

    desc "Copies the default SOLR config for the bundled Hydra Testing Server"
    task :config do
      fcfg = File.join(Rails.root,"fedora","conf","fedora.fcfg")
      if File.exists?(fcfg)
        puts "copying over fedora.fcfg"
        cp("#{fcfg}", 'jetty/fedora/default/server/config/', :verbose => true)
      else
        puts "skipping fedora.fcfg"
      end
    end

  end
end
