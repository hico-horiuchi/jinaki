ENV['RACK_ENV'] = 'test'

require 'ostruct'
require 'simplecov'

SimpleCov.start

require File.expand_path('../lib/jinaki', __dir__)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.include Rack::Test::Methods

  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  def app
    Rack::URLMap.new({
                       '/' => Jinaki::App::Root,
                       '/esa' => Jinaki::App::Esa
                     })
  end
end
