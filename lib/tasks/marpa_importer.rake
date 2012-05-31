require 'marpa/csv_importer'
require 'marpa/s3_importer'
require 'marpa/talk_matcher'
require 'marpa/title_populator'
namespace :marpa_importer do
  desc "Imports objects from CSV file"
  task :import_csv => [:environment] do
    if ENV["csv"].nil? 
      puts "You must specify the path to a csv file.  Example: rake marpa_importer:import_csv csv=\"lib/KTGR MP3.csv\""
    else
      file_path = ENV["csv"]
      importer = Marpa::CSVImporter.new
      importer.import( file_path )
    end
  end
  desc "Imports objects from S3 bucket & folder"
  task :import_s3 => [:environment] do
    importer = Marpa::S3Importer.new
    importer.import
  end
  desc "Match recordings to the corresponding Talks"
  task :match_talks => [:environment] do
    matcher = Marpa::TalkMatcher.new
    matcher.match
  end
  
  desc "Update Talk titles based on Course title" 
  task :populate_titles => [:environment] do
    populator = Marpa::TitlePopulator.new
    populator.populate_titles
  end
end

# This ci task adapted from lib/tasks/narm.rake in the narm project 
desc "Run ci"
task :ci do
  Rake::Task["hydra:jetty:config"].invoke
  
  require 'jettywrapper'
  jetty_params = Jettywrapper.load_config.merge({:jetty_home => File.join(Rails.root , 'jetty'), :startup_wait=>30 })
  
  error = nil
  error = Jettywrapper.wrap(jetty_params) do
      puts %x[rake test:fixtures RAILS_ENV=test]
      Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

namespace :test do
  desc "Load marpa test fixtures into solr/fedora"
  task :fixtures => [:environment] do
    #TODO -empty fedora first?
    loader =  ActiveFedora::FixtureLoader.new('spec/fixtures')
    
    fixtures_array = %w{programf:ktd_gyu_lama
    talkf:ktd_gyu_lama_1
    topicf:bodhicitta
    topicf:mahamudra
    locationf:ktd
    songf:five_poisons
    textf:gyu_lama
    textf:ngedon
    translatorf:arig
    translatorf:ecallahan
    fixture:1 fixture:2 fixture:3
    placef:boudha recordinginstantiationf:nagarjuna1 programf:nagarjuna_verses talkf:nagarjuna_verses_1 programtextf:1 textf:60_verses programtextf:2 textf:valid_cognition recordingf:nagarjuna_verses2 translatorf:kiki}
    
    # ['fixture:1', 'fixture:2', 'fixture:3']
    
    fixtures_array.each do |pid|
      puts "Loading #{pid}"
      loader.reload(pid)
    end
    
  end
end
