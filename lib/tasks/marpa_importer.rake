require 'marpa/csv_importer'
require 'marpa/s3_importer'
require 'marpa/talk_matcher'
require 'marpa/title_populator'
require 'hydra/fixture_loader'
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
  desc "Match recordings to the corresponding MarpaLecture objects"
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


namespace :test do
  desc "Load marpa test fixtures into solr/fedora"
  task :fixtures => [:environment] do
    #TODO -empty fedora first?
    loader =  Hydra::FixtureLoader.new('spec/fixtures')
    ['marpa:1', 'marpa:2', 'marpa:3'].each do |pid|
      puts "Loading #{pid}"
      loader.reload(pid)
    end
  end
end
