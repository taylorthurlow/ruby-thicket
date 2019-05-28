module FakeGit
  class Repo
    attr_accessor :directory, :commits

    def generate
      Dir.chdir(@directory)
      `git init`
      `git config commit.gpgsign false`
      `git checkout -b master 2>&1`
      @commits.each(&:generate)
    end

    def current_branch
      `git branch | grep \\* | cut -d ' ' -f2`.chomp
    end
  end
end
