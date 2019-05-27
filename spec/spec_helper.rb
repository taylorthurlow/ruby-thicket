# frozen_string_literal: true

require "simplecov"

unless ENV["NO_COVERAGE"]
  SimpleCov.start do
    add_filter "/vendor"
  end
end

require "bundler/setup"
Bundler.setup

require "thicket" # and any other gems you need

RSpec.configure do |config|
  # silence stdout and stderr
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    unless defined?(Byebug) || defined?(Pry)
      $stderr = File.open(File::NULL, "w")
      $stdout = File.open(File::NULL, "w")
    end
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

# allow rspec mocks in factory_bot definitions
FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end

#####
# Helper methods
#####
