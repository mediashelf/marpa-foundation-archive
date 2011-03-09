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