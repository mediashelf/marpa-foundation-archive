# require File.expand_path(File.dirname(__FILE__) + '/hydra_jetty.rb')
require "solrizer-fedora"

namespace :libra_oa do
  
  namespace :default_fixtures do

    LIBRA_OA_FIXTURE_FILES = [
        "libra-oa_1.foxml.xml",
        "libra-oa_2.foxml.xml",
        "libra-oa_3.foxml.xml",
        "libra-oa_4.foxml.xml",
        "libra-oa_5.foxml.xml",
        "libra-oa_6.foxml.xml",
        "libra-oa_7.foxml.xml",
        "libra-oa_8.foxml.xml"
    ]
    LIBRA_OA_FIXTURES = [
        "libra-oa:1",
        "libra-oa:2",
        "libra-oa:3",
        "libra-oa:4",
        "libra-oa:5",
        "libra-oa:6",
        "libra-oa:7",
        "libra-oa:8"
    ]

    desc "Load default libra-oa fixtures"
    task :load do
      LIBRA_OA_FIXTURE_FILES.each_with_index do |fixture,index|
        ENV["pid"] = nil
        ENV["fixture"] = "#{Rails.root}/spec/fixtures/libra-oa/#{fixture}"
        # logger.debug ENV["fixture"] 
        if index == 0
          Rake::Task["hydra:import_fixture"].invoke 
        elsif index > 0
          Rake::Task["hydra:import_fixture"].execute
        end 
      end
      LIBRA_OA_FIXTURES.each_with_index do |fixture,index|
        ENV["PID"] = fixture
        if index == 0
          Rake::Task["solrizer:fedora:solrize"].invoke 
        elsif index > 0
          Rake::Task["solrizer:fedora:solrize"].execute
        end
      end
    end

    desc "Remove default libra-oa fixtures"
    task :delete do
      LIBRA_OA_FIXTURES.each_with_index do |fixture,index|
        ENV["pid"] = fixture
        Rake::Task["hydra:delete"].invoke if index == 0
        Rake::Task["hydra:delete"].execute if index > 0
      end
    end

    desc "Refresh default libra-oa fixtures"
    task :refresh do
      Rake::Task["libra_oa:default_fixtures:delete"].invoke
      Rake::Task["libra_oa:default_fixtures:load"].invoke
    end
  end

end
