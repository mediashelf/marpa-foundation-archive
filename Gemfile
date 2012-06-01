source 'http://rubygems.org'

gem 'rails', '3.2.4'
gem 'blacklight', '>=3.3.4'
gem "hydra-head", :git => 'git://github.com/projecthydra/hydra-head.git',  :ref=>"25cb42c"
gem 'active-fedora', :git=>'git://github.com/projecthydra/active_fedora.git', :ref=>'c40b25c'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  # gem 'therubyracer'
  gem "bootstrap-sass-rails"
  gem 'jquery-ui-rails'
  gem 'jquery.fileupload-rails'

end
gem 'jquery-rails'

gem 'sqlite3'
gem "mysql"

gem 's3_swf_upload', :git => 'git://github.com/nathancolgate/s3-swf-upload-plugin'
gem "aws-sdk"
gem "haml"
gem "paperclip", "~> 2.4"
gem 'solrizer-fedora'


gem 'jettywrapper'

group :development, :test do
  gem 'rspec-rails'
  gem 'mocha'
  gem 'gherkin'
  gem "equivalent-xml", ">= 0.2.4"
end

group :test do
  gem 'cucumber-rails', :require=>false
  gem 'factory_girl_rails'
end

group :importer do
 gem 'fastercsv'
end
gem "devise"

gem 'unicorn'
