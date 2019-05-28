require "factory_bot"
require "faker"

require_relative "fake_git/repo"
require_relative "fake_git/commit"

module FakeGit
  include FactoryBot::Syntax::Methods
end
