# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'
Rails.env = 'test'
ActiveRecord::Base.establish_connection
abort("The Rails environment is running in production mode!") if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end