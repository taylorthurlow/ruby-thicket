# frozen_string_literal: true

require "optparse"

module Thicket
  Options = Struct.new(:name)

  class OptionParser
    attr_reader :options

    def initialize
      @options = {}
      parse ARGV
    end

    private

    def parse(options)
      args = Options.new("world")

      opt_parser = ::OptionParser.new do |opts|
        opts.banner = "Usage: thicket [options]"

        opts.on("-v", "--version", "Print the version number") do |v|
          args.name = v
          puts Thicket::VERSION
          exit
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end

        opts.on("-d", "--directory DIRECTORY", String, "Path to the project directory") do |project_directory|
          args.name = project_directory
          @options[:project_directory] = File.expand_path(project_directory)
        end

        opts.on("-n", "--commit-limit LIMIT", Integer, "Number of commits to parse before stopping") do |limit|
          args.name = limit
          @options[:limit] = limit
        end

        opts.on("-a", "--all", TrueClass, "Displays all branches on all remotes.") do |all|
          args.name = all
          @options[:all] = all
        end

        opts.on("-p", "--color-prefixes", TrueClass, "Adds coloring to commit message prefixes.") do |prefixes|
          args.name = prefixes
          @options[:color_prefixes] = prefixes
        end

        opts.on("--git-binary BINARY", String, "Path to a git executable") do |git_binary|
          args.name = git_binary
          @options[:git_binary] = File.expand_path(git_binary)
        end
      end

      opt_parser.parse!(options)
    rescue ::OptionParser::ParseError => e
      puts e.message
      exit
    end
  end
end
