# frozen_string_literal: true

require "fileutils"
require "time"

module Thicket
  class Log
    LOG_PARSE_REGEX = /[a-f0-9]{7}.+?m(.+?) .+?m\{(.+?)\}.+?m (?:\((.+?)\))?.+?m(.+$)/.freeze

    def initialize(options)
      @options = options
      @count_parsed = 0
    end

    # Gets a printable version of the log for purposes of printing to a
    # terminal. This effectively builds the final printable log to display to
    # the user.
    def print
      FileUtils.cd(git_working_directory)
      `#{git_log_command}`.encode("UTF-8", invalid: :replace, undef: :replace)
                          .split("\n")
                          .each do |l|
        puts process_git_log_line(l)

        next unless @options[:limit] && @count_parsed >= @options[:limit]

        puts "..."
        puts "Stopped after #{@options[:limit]} commits. More commit history exists."
        exit
      end
    rescue Errno::EPIPE, SystemExit, Interrupt
      exit
    end

    private

    # Takes a single line of raw, colored git log output and manipulates it
    # into the desired format.
    def process_git_log_line(line)
      @padding_char = @padding_char == " " ? "-" : " "

      line.match(LOG_PARSE_REGEX) do |matcher|
        line = process_date_time(matcher[1], line, matcher[3])
        line = process_refs(matcher[3], line) if matcher[3] && @options[:consolidate_refs]
        line = process_message_prefix(matcher[4], line) if @options[:color_prefixes]
        line = process_author_name(matcher[2], line)
        @count_parsed += 1
      end

      line
    end

    # Takes an input log string and a commit date/time and replaces it in the
    # log string with a formatted version.
    def process_date_time(time_string, line, have_refs)
      seconds_ago = Time.now - Time.iso8601(time_string)
      measure = TimeMeasure.measures.find { |m| m.threshold < seconds_ago }
      quantity = (seconds_ago / measure.length).floor
      to_sub = +"#{quantity}#{measure.abbreviation}".rjust(3)
      to_sub << "\e[31m" if have_refs # add color if we have refs in this line

      line.sub(time_string, to_sub)
    end

    # Takes an input log string and a refs list, and formats the refs list in a
    # more consolidated way.
    def process_refs(refs, line, main_remote: "origin")
      original_refs = refs
      refs = strip_color(refs).split(",").map(&:strip)

      head_ref_index = refs.find_index { |r| r.start_with?("HEAD -> ") }
      refs[head_ref_index].slice!("HEAD -> ") if head_ref_index

      refs.each do |r|
        refs.delete(r) if r == "#{main_remote}/HEAD"
        next if r.start_with?("#{main_remote}/")

        branch = "#{main_remote}/#{r}"
        if refs.include?(branch)
          refs.delete(branch)
          r << "#"
        end
      end

      line.sub(original_refs, refs.join(", "))
    end

    # Takes an input log string and commit message, finds commit messages
    # prefixes, and darkens them.
    def process_message_prefix(message, line)
      prefix_regex = %r{^(?=.*[0-9])([A-Z\d-]+?[: \/])}
      message.match(prefix_regex) do |matcher|
        prefix = matcher[1]
        return line.sub(/([^\/])#{prefix}/, "\\1\e[30m#{prefix}\e[m")
      end

      line
    end

    # Takes an input log string and commit author, and moves it from the normal
    # position in the string to a right-justified location.
    def process_author_name(author, line)
      line.sub!("\e[34m{#{author}}\e[31m ", "")
      total_length = strip_color(line).length
      over = (total_length + author.length + 1) - terminal_width
      line = line[0...-over] if over > 0

      total_length = strip_color(line).length
      spaces_needed = terminal_width - total_length - author.length - 2
      if spaces_needed < 0
        line = +"#{line[0...-spaces_needed - 5]}...  "
      else
        line << " \e[30m"
        line << @padding_char * spaces_needed
        line << " \e[m"
      end

      line << "\e[34m#{author}\e[m"
    end

    # Strips ANSI color escape codes from a string. Colorize's
    # String#uncolorize would be used, but it seems to only remove escape codes
    # which match a strict pattern, which git log's colored output doesn't
    # follow.
    def strip_color(string)
      color_escape_regex = /\e\[([;\d]+)?m/
      string.gsub(color_escape_regex, "").chomp
    end

    # Gets the width of the terminal window in columns. Memoizes the result to
    # avoid more shell calls, and because the terminal size won't be changing
    # during the execution of this script.
    def terminal_width
      @terminal_width ||= `tput cols`.to_i
    rescue Errno::ENOENT
      puts "Failed to determine terminal column width."
      exit
    end

    # The command string which gets the raw git log input straight from git.
    # Includes all formatting and color escape codes.
    def git_log_command
      format = "%C(yellow)%h %Cgreen%aI %Cblue{%an}%Cred%d %Creset%s"
      cmd = +"#{git_executable} log --oneline --decorate --color " \
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
