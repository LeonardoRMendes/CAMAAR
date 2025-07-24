source 'https://rubygems.org'
ruby '3.4.4'

gem 'rails', '8.0.2'
gem 'sqlite3'
gem 'puma', '>= 6.5'
gem 'sass-rails', '>= 6'
gem 'turbo-rails', '>= 2.0'
gem 'stimulus-rails'
gem 'jbuilder', '>= 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bcrypt'
gem 'sprockets-rails'
gem 'csv', '>= 3.2'

# Rails 8 específicos
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "debug"
end

group :test do
  gem 'simplecov', require: false
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
  gem 'shoulda-matchers'
end