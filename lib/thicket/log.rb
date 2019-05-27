# frozen_string_literal: true

require "colorize"
require "fileutils"

module Thicket
  class Log
    LOG_PARSE_REGEX = /[a-f0-9]{7}.+?m(.+?) .+?m\{([\w ]+)\}.+?m (?:\((.+?)\))?.+?m(.+$)/.freeze

    def initialize(options)
      @options = options
    end

    # Gets a printable version of the log for purposes of printing to a
    # terminal. This effectively builds the final printable log to display to
    # the user.
    def to_s
      FileUtils.cd(git_working_directory)
      `#{git_log_command}`
    end

    private

    # Gets the width of the terminal window in columns. Memoizes the result to
    # avoid more shell calls, and because the terminal size won't be changing
    # during the execution of this script.
    def terminal_width
      @terminal_width ||= `tputs cols`.to_i
    end

    # The command string which gets the raw git log input straight from git.
    # Includes all formatting and color escape codes.
    def git_log_command
      format = "%C(yellow)%h %Cgreen%aI %Cblue{%an}%Cred%d %Creset%s"
      cmd = "#{git_executable} log --oneline --decorate --color " \
      "--graph --pretty=format:'#{format}'"
      cmd << " --all" if @options[:all]

      cmd
    end

    # The path to the git executable. Honors the passed in command line option,
    # and falls back to just "git".
    def git_executable
      @options[:git_binary] || "git"
    end

    # The directory which represents the git project that we want to retreive
    # logs for. Uses the command line option if it was provided, and falls back
    # to the current working directory otherwise.
    def git_working_directory
      @options[:project_directory] || Dir.pwd
    end
  end
end
