# frozen_string_literal: true

require "simplecov"
require "database_cleaner"
require File.expand_path("../../config/environment", __FILE__)
require "active_support/testing/time_helpers"
require_relative "../config/application"

ENV["APP_ENV"] = "test"
SimpleCov.start

# require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner[:active_record]
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner[:active_record]
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].start

    # stub_request(:get, /api.chucknorris.io/).to_return(status: 200, body: { value: "stubbed response" }.to_json, headers: {})
  end

  config.after do
    DatabaseCleaner[:active_record].clean
  end
end
