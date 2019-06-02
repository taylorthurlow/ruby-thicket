require "spec_helper"

RSpec.describe "Git" do
  it "generates a git repo" do
    allow_any_instance_of(Thicket::Log).to receive(:terminal_width).and_return(120)

    repo = create(:repo)
    create_list(:commit, 100, repo: repo)

    repo.generate

    args_list = [
      ["-d", repo.directory, "--color-prefixes", "--all"],
      ["-d", repo.directory, "--all", "-n", "30"],
      ["-d", repo.directory, "--all", "-r"],
      ["-h"],
      ["-v"],
    ]

    args_list.each do |args|
      ARGV = args
      parser = Thicket::OptionParser.new
      Thicket::Log.new(parser.options).print
    end
  end
end
