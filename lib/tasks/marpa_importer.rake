namespace :marpa_importer do
  desc "Imports objects from CSV file"
  task :import_csv => [:environment] do
    if ENV["csv"].nil? 
      puts "You must specify the path to a csv file.  Example: rake marpa_importer:import_csv csv=\"lib/KTGR MP3.csv\""
    else
      file_path = ENV["csv"]
      puts "foo"
    end
  end
end