# spec/spec_helper.rb

# Code coverage (must be first)
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'
  add_group 'Domain', 'app/domain'
  add_group 'Repositories', 'app/repositories'
  add_group 'Workers', 'app/workers'
  add_group 'Models', 'app/models'
end

RSpec.configure do |config|
  # Expect syntax (expect vs should)
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect  # Use expect() syntax only
  end

  # Mocking framework
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Shared context metadata behavior
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Limit stack traces to application code
  config.filter_run_when_matching :focus
  
  # Run specs in random order (catch hidden dependencies)
  config.order = :random
  
  # Seed global randomization (for reproducibility)
  Kernel.srand config.seed

  # Allow one-liner test syntax (subject { ... })
  config.disable_monkey_patching!

  # Show slowest examples
  config.profile_examples = 10
end