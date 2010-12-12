# require File.expand_path(File.dirname(__FILE__) + '/hydra_jetty.rb')
require "solrizer-fedora"

namespace :hydra do
  
  desc "Delete and re-import the fixture identified by pid" 
  task :refresh_fixture => [:delete,:import_fixture]
  
  desc "Delete the object identified by pid"
  task :delete => :environment do
    # If a destination url has been provided, attampt to export from the fedora repository there.
    if ENV["destination"]
      Fedora::Repository.register(ENV["destination"])
    end
    
    # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
    ActiveFedora.init unless Thread.current[:repo]
    
    if ENV["pid"].nil? 
      puts "You must specify a valid pid.  Example: rake hydra:delete pid=demo:12"
    else
      pid = ENV["pid"]
      # puts "Deleting '#{pid}' from #{Fedora::Repository.instance.fedora_url}"
      begin
        ActiveFedora::Base.load_instance(pid).delete
      rescue ActiveFedora::ObjectNotFoundError
        # The object has already been deleted (or was never created).  Do nothing.
      end
      puts "Deleted '#{pid}' from #{Fedora::Repository.instance.fedora_url}"
    end
  end
  
  desc "Delete a range of objects in a given namespace.  ie 'rake hydra:purge_range[demo, 22, 50]' will delete demo:22 through demo:50"
  task :purge_range => :environment do |t, args|
    # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
    ActiveFedora.init unless Thread.current[:repo]
    
    namespace = ENV["namespace"]
    start_point = ENV["start"].to_i
    stop_point = ENV["stop"].to_i
    unless start_point < stop_point 
      raise StandardError "start point must be less that end point."
    end
    puts "Deleting #{stop_point - start_point} objects from #{namespace}:#{start_point.to_s} to #{namespace}:#{stop_point.to_s}"
    i = start_point
    while i <= stop_point do
      pid = namespace + ":" + i.to_s
      begin
        ActiveFedora::Base.load_instance(pid).delete
      rescue ActiveFedora::ObjectNotFoundError
        # The object has already been deleted (or was never created).  Do nothing.
      end
      puts "Deleted '#{pid}' from #{Fedora::Repository.instance.fedora_url}"
      i += 1
    end
  end
  
  desc "Export the object identified by pid into spec/fixtures. Example:rake hydra:harvest_fixture pid=druid:sb733gr4073 source=http://fedoraAdmin:fedoraAdmin@127.0.0.1:8080/fedora"
  task :harvest_fixture => :environment do
        
    # If a source url has been provided, attampt to export from the fedora repository there.
    if ENV["source"]
      Fedora::Repository.register(ENV["source"])
    end
    
    # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
    ActiveFedora.init unless Thread.current[:repo]
    
    if ENV["pid"].nil? 
      puts "You must specify a valid pid.  Example: rake hydra:harvest_fixture pid=demo:12"
    else
      pid = ENV["pid"]
      puts "Exporting '#{pid}' from #{Fedora::Repository.instance.fedora_url}"
      foxml = Fedora::Repository.instance.export(pid)
      filename = File.join("spec","fixtures","#{pid.gsub(":","_")}.foxml.xml")
      file = File.new(filename,"w")
      file.syswrite(foxml)
      puts "The object has been saved as #{filename}"
    end
  end
  
  desc "Import the fixture located at the provided path"
  task :import_fixture => :environment do
        
    # If a destination url has been provided, attampt to export from the fedora repository there.
    if ENV["destination"]
      Fedora::Repository.register(ENV["destination"])
    end
    
    # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
    ActiveFedora.init unless Thread.current[:repo]
    
    if !ENV["pid"].nil?
      pid = ENV["pid"]
      filename = File.join("spec","fixtures","#{pid.gsub(":","_")}.foxml.xml")
    elsif !ENV["fixture"].nil? 
      filename = ENV["fixture"]
    else
      puts "You must specify a path to the fixture or provide its pid.  Example: rake hydra:import_fixture fixture=spec/fixtures/demo_12.foxml.xml"
    end
    
    if !filename.nil?
      puts "Importing '#{filename}' to #{Fedora::Repository.instance.fedora_url}"
      file = File.new(filename, "r")
      result = foxml = Fedora::Repository.instance.ingest(file.read)
      if result
        puts "The fixture has been ingested as #{result}"
        if !pid.nil?
          solrizer = Solrizer::Fedora::Solrizer.new 
          solrizer.solrize(pid) 
        end    
      else
        puts "Failed to ingest the fixture."
      end
    end    
    
  end

  namespace :default_fixtures do

    FIXTURES = [
        "hydrangea:fixture_mods_article1",
        "hydrangea:fixture_mods_article3",
        "hydrangea:fixture_file_asset1",
        "hydrangea:fixture_mods_article2",
        "hydrangea:fixture_uploaded_svg1",
        "hydrangea:fixture_archivist_only_mods_article",
        "hydrangea:fixture_mods_dataset1"
    ]

    desc "Load default Hydra fixtures"
    task :load do
      FIXTURES.each_with_index do |fixture,index|
        ENV["pid"] = fixture
        Rake::Task["hydra:import_fixture"].invoke if index == 0
        Rake::Task["hydra:import_fixture"].execute if index > 0
      end
    end

    desc "Remove default Hydra fixtures"
    task :delete do
      FIXTURES.each_with_index do |fixture,index|
        ENV["pid"] = fixture
        # puts "#{ENV["pid"]}"
        Rake::Task["hydra:delete"].invoke if index == 0
        Rake::Task["hydra:delete"].execute if index > 0
      end
    end

    desc "Refresh default Hydra fixtures"
    task :refresh do
      FIXTURES.each_with_index do |fixture,index|
        ENV["pid"] = fixture
        if index == 0
          Rake::Task["hydra:delete"].invoke if index == 0
          Rake::Task["hydra:import_fixture"].invoke if index == 0
        else 
          Rake::Task["hydra:delete"].execute if index > 0
          Rake::Task["hydra:import_fixture"].execute if index > 0
        end
      end
    end
  end

end
