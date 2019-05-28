# frozen_string_literal: true

require "simplecov"

unless ENV["NO_COVERAGE"]
  SimpleCov.start do
    add_filter "/vendor"
  end
end

require "bundler/setup"
Bundler.setup

require "time"
require "fileutils"

require "factory_bot"
require "thicket"

require_relative "support/fake_git"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  original_stdout = $stdout
  original_stderr = $stderr

  config.before(:all) do
    unless defined?(Byebug) || defined?(Pry)
      $stdout = File.open(File::NULL, "w")
      $stderr = File.open(File::NULL, "w")
    end
  end

  config.after(:all) do
    $stdout = original_stdout
    $stderr = original_stderr
  end
end
