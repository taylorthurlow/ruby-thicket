module FakeGit
  class Commit
    attr_accessor :repo, :message, :changed_files, :author_name,
                  :author_email, :author_date

    def generate
      Dir.chdir(@repo.directory)
      changed_files.each do |f|
        full_path = File.join(@repo.directory, f)

        `git config user.name "#{@author_name}"`
        `git config user.email "#{@author_email}"`
        `touch #{full_path}`
        `git add #{full_path}`
        `git commit -m "#{@message}" --date="#{@author_date}"`

        # 20% chance to branch off
        if rand(1..100) <= 20
          `git checkout -b #{SecureRandom.hex(5)} 2>&1`
        elsif rand(1..100) <= 20 && @repo.current_branch != "master"
          # 20% chance to merge back to master
          merge_branch = @repo.current_branch
          `git checkout master 2>&1`
          `git merge --no-ff -m "Merging branch #{merge_branch}" #{merge_branch}`
        end
      end
    end
  end
end
