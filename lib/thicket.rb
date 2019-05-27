# frozen_string_literal: true

require "thicket/version"
require "thicket/log"
require "thicket/option_parser"
require "thicket/time_measure"

module Thicket
  def self.root
    File.expand_path("..", __dir__)
  end
end
