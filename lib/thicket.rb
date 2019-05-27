# frozen_string_literal: true

require "thicket/version"
require "thicket/log"
require "thicket/option_parser"

module Thicket
  def self.root
    File.expand_path("..", __dir__)
  end
end
