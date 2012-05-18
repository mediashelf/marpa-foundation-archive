source 'http://rubygems.org'

gem 'rails', '3.2.3'
gem 'jquery-rails'

gem 'sqlite3'
gem 'blacklight', '>=3.3.4'
gem "mysql"
gem 'solrizer-fedora'

gem "hydra-head", :git => 'git://github.com/projecthydra/hydra-head.git',  :ref=>"5a55e23"
gem 's3_swf_upload', :git => 'git://github.com/nathancolgate/s3-swf-upload-plugin'
gem "aws-s3"
gem "aws-sdk"
gem "haml"
gem "paperclip", "~> 2.4"


gem 'jettywrapper'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'mocha'
  gem 'gherkin'
  gem "equivalent-xml", ">= 0.2.4"

  gem 'ruby-debug'
  gem "rbx-require-relative", "0.0.5"
end
group :test do
  gem 'cucumber-rails', :require=>false
  gem 'factory_girl', '<3.0.0' # 3+ depends on ruby 1.9.2+
  gem 'factory_girl_rails'
end

group :importer do
 gem 'fastercsv'
end
gem "devise"
