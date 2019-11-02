source 'https://rubygems.org'

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

gem 'rails', '3.2.22'
gem 'puma'
gem 'whenever', :require => false
gem 'activerecord-import'
gem 'parallel'

gem 'houston'
gem 'gcm'
gem 'jwt'
gem 'http-2', '~> 0.8.1'
gem 'net-http2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#In Rails 3.2, make sure font-awesome-rails is outside the bundler asset group so that these helpers are automatically loaded in production environments.
gem "font-awesome-rails"
gem "simplecov"
gem 'test-unit', '~> 3.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails'
  #gem 'bootstrap-sass', '~> 2.3.2'
  # bootstrap-sass is no longer compatible with Rails 3. The latest version of bootstrap-sass compatible with Rails 3.2 is v3.1.1.0
  gem 'bootstrap-sass', '~> 3.4.1'
  gem 'sass-rails', '>= 3.2'
  gem 'sprockets-rails'
  gem 'sprockets'
  gem 'autoprefixer-rails'
  gem 'compass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier'
  gem 'less-rails'
  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'rails3-jquery-autocomplete'
gem 'compass'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-fileinput'
end

# File uploader
gem 'carrierwave'
gem 'rmagick'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'doorkeeper', '~> 0.4.2'
gem 'versionist', '~> 0.3.1'
gem 'rabl'
gem 'jbuilder'
gem "meta_search"
gem 'haml'
gem 'kaminari'
gem 'activeadmin', '~> 0.6.0'
gem 'formtastic'
gem 'thor'
gem 'oauth2'
gem "omniauth-facebook"
gem "koala"
gem 'rack-cors', :require => 'rack/cors'
# gem 'msgpack', '~> 0.4.7'
gem "quiet_assets"
# gem "nokogiri"
gem "bcrypt"
gem "rails-i18n"
gem "cancan"

#gem 'capistrano'
#gem 'capistrano_colors'
#gem 'rvm-capistrano'

group :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'mysql2', '~> 0.3.21'
end

gem 'rspec-rails', :group => [ :test, :development ]
group :test do
  gem 'guard-rspec'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-fsevent', :require => darwin_only('rb-fsevent')
  gem 'growl', :require => darwin_only('growl')
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'factory_girl'
  gem 'ffaker'
  gem 'vcr'
  gem 'accept_values_for'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
end
