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
end