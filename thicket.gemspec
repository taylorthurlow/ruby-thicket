# frozen_string_literal: true

$LOAD_PATH << File.expand_path("lib", __dir__)
require "thicket/version"

Gem::Specification.new do |s|
  s.name = "thicket"
  s.version = Thicket::VERSION
  s.license = "MIT"
  s.summary = "An opinionated replacement for git's log command."
  s.description = <<~DESCRIPTION
    Git's default log command gets the job done, but its formatting capabilities
    sometimes leave something to be desired. Thicket is an opinionated replacement for
    "git log".
  DESCRIPTION
  s.author = "Taylor Thurlow"
  s.email = "taylorthurlow8@gmail.com"
  s.files = Dir["{bin,lib}/**/*"]
  s.homepage = "https://github.com/taylorthurlow/thicket"
  s.bindir = "bin"
  s.executables = ["thicket"]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.3"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rufo", "~> 0.5.1"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "solargraph"
end
